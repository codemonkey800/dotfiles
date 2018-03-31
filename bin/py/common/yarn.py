import json

from plumbum import (
    colors,
    commands,
    local as sh,
)


class PackageConfig:
    def load_local(self, manifest_file):
        if not manifest_file.exists():
            raise ValueError(f"Manifest file doesn't exist: {manifest_file}")
        with open(manifest_file) as f:
            self._config = json.load(f)

    def load_remote(self, package_name):
        yarn = sh['yarn']

        try:
            response = yarn('info', '--json', package_name)
            self._config = json.loads(response)['data']
        except commands.ProcessExecutionError:
            raise ValueError(f'`{package_name}` does not exist!')

    def __getitem__(self, key):
        return self._config.get(key, None)


def format_versions(config_dict):
    packages = sorted(config_dict.items(), key=lambda package: package[0])

    longest_package_name =  0
    for package_name in config_dict.keys():
        longest_package_name = max(longest_package_name, len(package_name))

    return [
        f'{package_name:<{longest_package_name}} @ {version}'
        for package_name, version in packages
    ]


def print_label(label):
    print(colors.green & colors.bold | label)


def print_not_found(package_name):
    print(colors.red & colors.bold | 'Package not found:', end=' ')
    colors.green.print(package_name)
