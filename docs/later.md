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

