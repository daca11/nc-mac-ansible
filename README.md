# daca11's Ansible automated app installer

This playbook uses roles from Jeff Geerling's ([Mac Collection for Ansible](https://github.com/geerlingguy/ansible-collection-mac)) collection:

- `geerlingguy.mac.homebrew` ([documentation](https://github.com/geerlingguy/ansible-collection-mac/blob/master/roles/homebrew/README.md))
- `geerlingguy.mac.mas` ([documentation](https://github.com/geerlingguy/ansible-collection-mac/blob/master/roles/mas/README.md))
- `geerlingguy.mac.dock` ([documentation](https://github.com/geerlingguy/ansible-collection-mac/blob/master/roles/dock/README.md))

## Usage

1. Change the `vars` section of the `main.yml` playbook with apps you need from homebrew, App Store & in dock.

2. Install Homebrew from Self-Service app

3. Install ansible from homebrew `brew install ansible`

4. Make sure you're logged in AppStore

5. Run the playbook and enter your system's password `ansible-playbook -K main.yml`
