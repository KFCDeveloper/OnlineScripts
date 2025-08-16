from onedrivedownloader import download
ln = "https://unimore365-my.sharepoint.com/:u:/g/personal/215580_unimore_it/EUmqgpzRz3tPlD2KiVNRqdABBJl7qQYcIeROtMc4g2UeIA?e=zZtkLr"

download(ln, filename="file.zip", unzip=True, unzip_path="./data")