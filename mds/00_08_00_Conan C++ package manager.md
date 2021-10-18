---------------------------------

## Conan C/C++ package manager

Install CLI

```bash
pip install conan
```

Install CLI for jfrog server docker image

```bash
sudo mkdir -p /opt/docker/jfrog/artifactory
sudo chown 1030:1030 /opt/docker/jfrog/artifactory`
sudo docker run --name artifactory-cpp-ce -d  -p 8082:8082 -p 8081:8081 -v /opt/docker/jfrog/artifactory:/var/opt/jfrog/artifactory docker.bintray.io/jfrog/artifactory-cpp-ce:7.19.4`
sudo docker logs -f artifactory-cpp-ce http://jfrog_ip_address:8081/ admin/password
```

jfrog server docker compose configure

```bash
  artifactory-cpp-ce:
    image: docker.bintray.io/jfrog/artifactory-cpp-ce:7.19.4
    ports:
      - '8082:8082'
    restart: always
    volumes:
      - /opt/docker/jfrog/artifactory:/var/opt/jfrog/artifactory
```

---------------------------------

### jfrog server setup

- Create a normal user account -> `deepkh`
- Create a local repo which named as `conan-local`
- Assign `conan-local` with deploy/write permission  for user `deepkh`
- Assign `conan-local` with read permission  for user `anonymous`
- Create a `conan` virtual-repo which 
	- `conan-local` included
	- Set Default Deployment Repository  to `conan-local` (now you can deploy to this `conan` virtual repo)
- Administration -> Security -> Settings -> Allow Anonymouse Access

### client account setup
- `conan config set general.revisions_enabled=True`
- `conan remote remove conan-center`
- `conan user --clean`
- login jfrog by normal user -> deepkh
	- Click the top-right corner button of `SetMe up`
		- for `conan` virtual repo (this repo can read by anonymous, and can read/deploy/write by user deepkh)
			- `conan remote add conan https://jfrog_ip_address/artifactory/api/conan/conan False -f`
			- add deploy/write user (Can ignore this step if no need for upload)
				- `conan user -p hash_code_prompt_from_jfrogs_web_ui -r conan deepkh`

---------------------------------

### Basic CLI

- Search packages from local cache:
	- `conan search "*"`
- Search packages from remote conan server:
	- `conan search "*" -r all`
- Export package to local cache
	- `conan export . user/channel`
- Export prebuilt package to local cache (no need to specify `--build=zlib` on install command)
	- `conan export-pkg . user/channel`
- Install and build package (if package not exist from local cache then will download package from remote conan server)
	- `conan install zlib/1.2.9@user/channel --build=zlib `
- Install and build package by specified conanfile.txt and generate `conanbuildinfo.cmake`, `conanbuildinfo.mak`
	- `conan install conanfile.txt -r=conan`
	- conanfile.txt
		- 
		```bash
			[requires]
			zlib3/1.2.9@user/channel

			[generators]
			make
			cmake
 		```
- Install and build package and generate `conanbuildinfo.cmake`, `conanbuildinfo.mak`
	- `conan install zlib3/1.2.9@user1/channel1 -r conan -g make -g cmake`
- Install and build package with reversion
	- `conan install zlib3/1.2.9@user1/channel1#reversion_hash`
- Upload package from local cache to remote conan server
	- `conan upload zlib3/1.2.9@user/channel --all -r=conan`


