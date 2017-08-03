# Automation Labs
________________________________________________________________________________

## The Project

### About

The main purpose of this project is to build and compare different *Automation
Labs* using `ansible` as the core piece of them all.

Another purpose is to do an analysis of each tool tested in the lab, so we can
help people decide which one to pick.

### Tools Tested

Above, follows the list of the current tools that are planned to be implemented
and tested (the ones marked with a check are the ones that are already tested):

- [ ] Ansible Tower
- [x] Jenkins
- [x] Rundeck
- [ ] Semaphore

### Directory Structure


________________________________________________________________________________

## Using

### Prerequisites

> _Not yet implemented..._

### Starting the Lab

> _Not yet implemented..._
________________________________________________________________________________

## Analysis

### Ansible Tower

> _Not yet implemented..._

### Jenkins

#### Plugins

- [Ansible Plugin](https://wiki.jenkins.io/display/JENKINS/Ansible+Plugin)

#### Integrations

Plugin         | Remote Nodes | Inventory | Facts | Commands | Modules | Playbooks | Variables |
-------------- | ------------ | --------- | ----- | -------- | ------- | --------- | --------- |
Ansible Plugin | Yes          | No        | No    | Yes      | Yes     | Yes       | Yes       |

- Ansible nodes could be added and labeled in Jenkins to be called later
- The plugin has no integrations with Ansible Inventory
- The plugin makes no use of Facts
- Commands/Modules/Playbooks could be used
- Extra-vars could be passed through Build Parameters

### Rundeck

#### Plugins

- [Rundeck Ansible Plugin](https://github.com/Batix/rundeck-ansible-plugin)

#### Integrations

Plugin                 | Remote Nodes | Inventory | Facts | Commands | Modules | Playbooks | Variables |
---------------------- | ------------ | --------- | ----- | -------- | ------- | --------- | --------- |
Rundeck Ansible Plugin | No           | Yes       | Yes   | Yes      | Yes     | Yes       | Yes       |

- The inventory seems to be imported just once
- Facts are good (perhaps, the problem of inventory beeing imported once remains)
- Commands are good (the command is passed through Ansible's `shell` module)
- The Modules/Playbooks integration is weak (you need to specify the object path)
- Roles ???
- Variables can be passed through 'extra-vars'

### Semaphore

> _Not yet implemented..._

















