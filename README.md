# Homebrew on aarch64 Linux

## Install Homebrew on aarch64 Linux

To freshly install Homebrew on aarch64 Linux, run:

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ZhongRuoyu/homebrew-aarch64-linux/HEAD/install.sh)"
```

> [!WARNING]
> You should be aware that
> [Homebrew on aarch64 Linux is not officially supported](https://docs.brew.sh/Homebrew-on-Linux#arm-unsupported).

To install Homebrew on officially supported platforms, refer to
[the official installation instructions](https://docs.brew.sh/Installation).

To uninstall Homebrew, run
[the official uninstall script](https://github.com/Homebrew/install#uninstall-homebrew).

## Bootstrapping Homebrew with Portable Ruby for aarch64 Linux

If you have an existing Homebrew installation on aarch64 Linux, you can
bootstrap it with the Portable Ruby ported to aarch64 Linux.
To do so, refer to the instructions at
[the ZhongRuoyu/homebrew-portable-ruby-aarch64-linux repository](https://github.com/ZhongRuoyu/homebrew-portable-ruby-aarch64-linux#bootstrapping-homebrew-with-portable-ruby-for-aarch64-linux).

## Docker Images

Docker images are also built for Homebrew on aarch64 Linux.
Images are updated nightly and published on
[Docker Hub](https://hub.docker.com/r/zhongruoyu/homebrew-aarch64-linux).

To start a container using the latest image, run:

```shell
docker run --platform linux/aarch64 zhongruoyu/homebrew-aarch64-linux
```

## License

This repository is [MIT-licensed](LICENSE).

Homebrew is licensed under
[the BSD-2-Clause license](https://github.com/Homebrew/brew/blob/HEAD/LICENSE.txt).
The installation script and Dockerfile are adapted from
[Homebrew/install](https://github.com/Homebrew/install/blob/HEAD/install.sh) and
[Homebrew/brew](https://github.com/Homebrew/brew/blob/HEAD/Dockerfile),
respectively. so Homebrew's license terms apply.
