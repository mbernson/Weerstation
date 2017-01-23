# Configuratiemanagement

Deze map bevat het configuratiemanagement voor dit project.
We gebruiken de automatiseringstool [Ansible](https://www.ansible.com/) om servers automatisch te installeren.

## Ansible introductie

Ansible doet in principe niet meer dan commando's uitvoeren op  over SSH.

Een belangrijk principe is *idempotence*. Dat betekent dat je een configuratie zo vaak toe kunt passen als je wilt.

## How to

Navigeer voordat je begint naar deze map: `cd ansible`.

Controleer of de adressen in het bestand `inventory` voor jou klopppen en bereikbaar zijn over je netwerk.
Test of je de host(s) kunt bereiken met het commando: `ansible all -m ping`.

Configuratie toepassen kan met: `ansible-playbook playbook.yml`.