# daca11's Ansible automated app installer for NC macs

Install all your needed apps through homebrew formulae (cli apps), casks (gui apps) or mas (Mac App Store) and customize your dock apps to your liking.

## Features

- Adapted to work with JAMF & PMC / Blueprint NC Macs
- Homebrew must be installed from self-service app for this playbook to work
- System password only needs to be specified once in the `homebrew_sudo_password` variable
- Run only part of the playbook by specifying the corresponding tag: `cli-tools`, `homebrew`, `mas`, `dock`
- Upgrade brew casks, formulae & Mac App Store with `upgrade.yml` playbook

This playbook uses roles from Jeff Geerling's ([Mac Collection for Ansible](https://github.com/geerlingguy/ansible-collection-mac)) collection:

- `geerlingguy.mac.homebrew` ([documentation](https://github.com/geerlingguy/ansible-collection-mac/blob/master/roles/homebrew/README.md)) -> adapted to skip homebrew installation and only install specified taps/casks/formulae
- `geerlingguy.mac.mas` ([documentation](https://github.com/geerlingguy/ansible-collection-mac/blob/master/roles/mas/README.md))
- `geerlingguy.mac.dock` ([documentation](https://github.com/geerlingguy/ansible-collection-mac/blob/master/roles/dock/README.md))

## Usage

1. Install Homebrew from Self-Service app

2. Install ansible from homebrew `brew install ansible`

3. Make sure you're logged in App Store

4. Install required roles `ansible-galaxy install -r requirements.yml`

5. Change the `vars` section of the `main.yml` playbook with apps you need from homebrew, App Store & in dock.

6. Put your mac's password in `homebrew_sudo_password` variable of `group_vars/all.yml` (required to install casks without asking for the password for each item). Remember to not commit your password in plain text if you're forking this repo!! (at least encrypt it with Ansible Vault).

7. Run the playbook `ansible-playbook main.yml`
