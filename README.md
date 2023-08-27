# homebrew-aarch64-linux

This repository holds the Dockerfile for
[Homebrew](https://github.com/Homebrew/brew) on aarch64 Linux. Images are built
nightly and published on Docker Hub.

To use the image, run:

```shell
docker run --platform linux/aarch64 zhongruoyu/homebrew-aarch64-linux
```

## License

This repository is [MIT-licensed](LICENSE).

Homebrew is licensed under the
[BSD-2-Clause license](https://github.com/Homebrew/brew/blob/master/LICENSE.txt).
The Dockerfile is adapted from
[Homebrew's](https://github.com/Homebrew/brew/blob/master/Dockerfile), so
Homebrew's license terms apply.
