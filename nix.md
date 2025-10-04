
### \#\# 1. Database Prerequisites (NixOS)

This is a one-time setup to prepare the PostgreSQL server on your NixOS system.

1.  **Configure PostgreSQL with TimescaleDB**
    Edit your `/etc/nixos/configuration.nix` file to include the PostgreSQL service with the `timescaledb_toolkit` extension.

    ```nix
    services.postgresql = {
      enable = true;
      package = pkgs.postgresql_16.withPackages (p: [
        p.timescaledb_toolkit
      ]);
    };
    ```

2.  **Apply the Configuration**
    Rebuild your system to install the configured PostgreSQL service.

    ```bash
    sudo nixos-rebuild switch
    ```

3.  **Create the Database and User**
    Use the `postgres` superuser to create the `thingsboard` database and a user for it. You will be prompted to set a password.

    ```bash
    sudo -u postgres createuser --pwprompt thingsboard
    sudo -u postgres createdb thingsboard --owner=thingsboard
    ```

-----

### \#\# 2. Install the Database Schema

This step uses the special installer built into the ThingsBoard JAR. It connects to the empty database you just created and populates it with all the necessary tables, indexes, and initial system data.

Run this command from the root of your project directory (`~/Desktop/thingsboard`).

```bash
# This command SETS UP your database using the built-in installer
DATABASE_TS_TYPE=sql \
SPRING_DATASOURCE_URL='jdbc:postgresql://localhost:5432/thingsboard' \
SPRING_DATASOURCE_USERNAME=postgres \
SPRING_DATASOURCE_PASSWORD=postgres \
SQL_POSTGRES_TS_KV_PARTITIONING=MONTHS \
java -cp ./application/target/thingsboard-*-boot.jar \
     -Dloader.main=org.thingsboard.server.ThingsboardInstallApplication \
     -Dinstall.data_dir=./application/target/data \
     -Dinstall.load_demo=true \
     org.springframework.boot.loader.launch.PropertiesLauncher
```

The command is successful when you see the output: `Installation finished successfully!`

-----

### \#\# 3. Run the ThingsBoard Server

With the database now fully prepared, you can start the main ThingsBoard server.

Run this command from the root of your project directory (`~/Desktop/thingsboard`).

```bash
# This command RUNS the main server application
DATABASE_TS_TYPE=sql \
SPRING_DATASOURCE_URL='jdbc:postgresql://localhost:5432/thingsboard' \
SPRING_DATASOURCE_USERNAME=postgres \
SPRING_DATASOURCE_PASSWORD=postgres \
SQL_POSTGRES_TS_KV_PARTITIONING=MONTHS \
java -Xms2G -Xmx2G -jar application/target/thingsboard-*-boot.jar
```

The server is now running. You can access the web UI at **`http://localhost:8080`**. ✅

Since you installed with the demo data, you can log in with these default credentials:

  * **System Administrator:** `sysadmin@thingsboard.org` / `sysadmin`
  * **Tenant Administrator:** `tenant@thingsboard.org` / `tenant`