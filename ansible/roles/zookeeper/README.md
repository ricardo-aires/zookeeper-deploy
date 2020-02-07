# zookeeper

Role that setup [ZooKeeper](https://zookeeper.apache.org).

> The solutions provided were designed for Proof of Concepts. Hence, are not to be treated as production ready, especially because of the lack of Security settings.

## Requirements

This role was created using [Ansible 2.9](https://docs.ansible.com/ansible/2.9/) for macOS and tested using the [centos/7](https://app.vagrantup.com/centos/boxes/7) boxes for [Vagrant v.2.2.6](https://www.vagrantup.com/docs/index.html) with [VirtualBox](https://www.virtualbox.org/) as a Provider.

The [Ansible modules](https://docs.ansible.com/ansible/2.9/modules/modules_by_category.html) used in the role are:

- [package](https://docs.ansible.com/ansible/latest/modules/package_module.html#package-module)
- [group](https://docs.ansible.com/ansible/2.9/modules/group_module.html#group-module)
- [user](https://docs.ansible.com/ansible/2.9/modules/user_module.html#user-module)
- [file](https://docs.ansible.com/ansible/2.9/modules/file_module.html#file-module)
- [get_url](https://docs.ansible.com/ansible/2.9/modules/get_url_module.html#get_url-module)
- [unarchive](https://docs.ansible.com/ansible/2.9/modules/unarchive_module.html#unarchive-module)
- [template](https://docs.ansible.com/ansible/2.9/modules/template_module.html#template-module)
- [service](https://docs.ansible.com/ansible/2.9/modules/service_module.html#service-module)

> We are using `systemd` to control the service.

## Role Variables

The next variables are set in [defaults](./defaults/main.yml) in order to be [easily overwrite](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html#variable-precedence-where-should-i-put-a-variable) and fetch a different version:

- `zookeeper_user`: to setup details for the `zookeeper` user.
- `zookeeper_version`: version of the ZooKeeper to be installed.
- `zookeeper_tarball_checksum`: if a different version is needed.

Some of the [ZooKeeper settings](https://zookeeper.apache.org/doc/r3.5.6/zookeeperAdmin.html#sc_configuration) can also be tweaked using variables which also are in [defaults](./defaults/main.yml):

- `zookeeper_tick_time`: the length of a single tick, which is the basic time unit used by ZooKeeper, as measured in milliseconds.
- `zookeeper_init_limit`: amount of time, in ticks, to allow followers to connect and sync to a leader.
- `zookeeper_sync_limit`: amount of time, in ticks, to allow followers to sync with ZooKeeper.
- `zookeeper_autopurge_purgeinterval`: the time interval in hours for which the purge task has to be triggered.
- `zookeeper_autopurge_snapretaincount`: number of most recent snapshots and the corresponding transaction logs in the dataDir and dataLogDir to keep.
- `zookeeper_max_client_cnxns`: number of concurrent connections (at the socket level) that a single client, identified by IP address, may make to a single member of the ZooKeeper ensemble.
- `zookeeper_jvm_heap_size`: Heap Size to be set to the ZooKeeper service.
- `zookeeper_nofile`: Setup the max open files for the ZooKeeper service.

Other variables are available in [vars](vars/main.yml), usually don't need to be changed, unless we have a need to use a different mirror, for example.

> Keep in mind that the way used to set the ZooKeeper Ensemble is by looping the hosts in the `zookeeper_ensemble` group set in the [inventory](tests/inventory)

## Dependencies

This role doesn't have any dependencies.

## Example Playbook

A working example using Vagrant and Virtual Box is setup under [tests](./tests/).
