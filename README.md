# htop.appimage

This project aims to provide an automated build process for creating an AppImage of the popular system monitoring tool, [htop](https://github.com/htop-dev/htop). AppImage is a format for distributing portable software on Linux without needing to install it. With this AppImage, users can run htop on various Linux distributions without worrying about compatibility or installation issues.

## How to Use

### Downloading the AppImage

You can download the latest release of the htop AppImage from the [Releases](https://github.com/henry-hsieh/htop.appimage/releases) page. Simply download the `.AppImage` file and make it executable using the following command:

```bash
chmod +x Htop-x86_64.AppImage
```

### Running htop

Once the AppImage is downloaded and made executable, you can run it from the terminal:

```bash
./Htop-x86_64.AppImage
```

Or put to your system binary path:

```bash
sudo cp ./Htop-x86_64.AppImage /usr/bin/htop
```

### Building from Source

If you want to build the htop AppImage from source yourself, you can clone this repository and run the provided build script. Ensure you have the necessary dependencies installed on your system:

- GNU Make
- Docker

```bash
git clone https://github.com/henry-hsieh/htop.appimage.git
cd htop.appimage
make -j
make install prefix=/path/to/install
```

This will generate the htop AppImage in the `build` directory.

## Contributing

Contributions to this project are welcome! If you encounter any issues or have suggestions for improvement, please feel free to open an issue or submit a pull request.

## License

This project is licensed under the [MIT License](LICENSE), which means you are free to use, modify, and distribute the code as you see fit.
