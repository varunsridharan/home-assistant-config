#name = data.get("name", "world")
name = hass.states.get('sun.sun').attributes['next_dusk']
logger.info(name)
hass.bus.fire(name, {"wow": "from a Python script!"})