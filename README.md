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
