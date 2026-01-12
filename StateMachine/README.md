# State Machine

This is a node based state machine that is to say the state machine is a node that has child nodes "states" and it manages which one runs. It is a very straight foward implementation
and is quite extensiable for most cases. Since the state machines initalization function can be extened to take any number of arguments you can pretty much pass the context you need to the state
machine and then on start up or even in the `init` function pass that data to all of the children (states)

## States

Each state is a node an must be the child of a State machine. Each states script can be extended to add the tansitions you desire. By seperating states in to node we can help keep the core logic
of each state clean and seperate.
