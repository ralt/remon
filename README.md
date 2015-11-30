# remon

remon does several things:

1. Listen for changes in all the video card ports:
  - If a monitor becomes connected, and it's involved in a known
    configuration, automatically apply the known configuration.
  - If a monitor becomes disconnected, apply the known configuration
    for the remaining connected monitors.
2. Save a list of monitors and the layout in a known configuration.

For 1., it is using `inotify-wait` on
e.g. `/sys/class/drm/card0-LVDS-1/status`.

The known configurations are stored in an sqlite database.

To apply the configurations, it uses xrandr.

To save the configurations, the user has to use a binary that accepts
the same arguments as xrandr. This will let remon know the
configuration to save, along with the list of edids.

The database will have a single table:

```sql
create table configurations (
    edids varchar(32) unique not null,
    xrandr_options text not null
);
```

`edids` is an md5sum of the list of edids (i.e. each port on the video
card). `xrandr_options` is the options passed to `xrandr`.

So the workflow is like this:

```
$ remon --output LVDS1 --auto --output VGA1 --auto --right-of LVDS1
# remon saves in the sqlite db xrandr's arguments and calls xrandr
# Disconnect your monitor, then run:
$ remon --output VGA1 --off
# remon saves in the sqlite db xrandr's arguments and calls xrandr
```

Next time the VGA1 monitor is connected, remon will automatically call
the xrandr command to restore the layout. When it's disconnected
again, same story.

This means the limitation is to set your configuration with a single
xrandr command.
