# KBaReD

### KDialog Backup Restore Database

Script hecho para exportar, importar o eliminar bases de datos **MySQL**.

Utiliza la biblioteca **QT** en específico la herramienta **KDialog**

### Dependencias:
* **KDialog**
    * Fedora
        ```bash
            sudo dnf install kdialog
    * Debian/Ubuntu
        ```bash
            sudo apt install kdialog
    * Arch Linux
        ```bash
            sudo pacman -S kdialog
    * OpenSUSE
        ```bash
            sudo zypper install kdialog
    * Void Linux
        ```bash
            sudo xbps-install -S kdialog
* **qdbus**
    * Fedora
        ```bash
            sudo dnf install qt6-qttools
    * Debian/Ubuntu
        ```bash
            sudo apt install qdbus-qt6
    * Arch Linux
        ```bash
            sudo pacman -S qt6-tools
    * OpenSUSE
        ```bash
            sudo zypper install qdbus-qt6
    * Void Linux
        ```bash
            sudo xbps-install -S qt6-tools

Despues de instalar la dependencia **qdbus** será necesario crear un enlace simbólico a esta.
* Buscar la dependencia de la siguiente manera:
    ```bash
    find /usr -name qdbus 2>/dev/null
* Cuando se localice la ruta donde se encuentra crear en enlace simbólico
    ```bash
    sudo ln -s /usr/lib/qt6/bin/qdbus /usr/bin/qdbus

### Ejecución
* Para ejecutarlo baja el script ```git clone https://github.com/texta84/KBaReD.git```, asignar permisos de ejecución ```chmod +x KBaReD.sh``` y ejecutarlo ```./KBaReD.sh```
* Puedes crear un enlace simbólico para ejecutarlo desde la consola solo escribiendo **KBaReD**, lo puedes hacer de esta forma ```sudo ln -s /home/user/KBaReD.sh /usr/bin/KBaReD``` y en la terminal solo escribes ```KBaReD``` para ejecutarlo
* Otra opción sería mover el archivo ```sh``` después de clonarlo a la carpeta ```/usr/bin``` de esta manera ```sudo mv /home/user/KBaReD/KBaReD.sh /usr/bin/KBaReD```
