### STEPS

1. **Open a terminal on your system.**
 ```bash
   git clone GIT_URL
   ```

2. **Navigate to the directory containing the scripts.** use:
   ```bash
   cd day8/cluster-setup-checks
   ```

3. **Make the scripts executable.** You need to change the permissions of the scripts to make them executable. Use the `chmod` command for each script:
   ```bash
   chmod +x verify-crc.sh
   chmod +x verify-oc.sh
   chmod +x verify-kafka.sh
   ```

4. **Run the scripts.** Now you can run each script by using `./` followed by the script name:
   
   ```bash
   ./verify-crc.sh
   ```
   
   ```bash
   ./verify-oc.sh
   ```

   ```bash
   ./verify-kafka.sh
   ```
