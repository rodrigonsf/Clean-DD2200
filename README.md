# NetWorker and Data Domain Space Reclamation

A documented workflow for selecting NetWorker save sets, preparing SSID-based deletion commands, executing the NetWorker maintenance step, and initiating Data Domain filesystem cleaning.

Originally published by Rodrigo N. S. Fernandes, under the username **RodrickNunes**, in Dell Community on November 28, 2020.

This repository preserves that historical procedure in a structured format, including command examples, screenshots, safety considerations, and references.

## Table of Contents

- [Safety Notice](#safety-notice)
- [Overview](#overview)
- [Historical Environment](#historical-environment)
- [Scope and Limitations](#scope-and-limitations)
- [Prerequisites](#prerequisites)
- [Procedure](#procedure)
  - [1. Identify the Target Save Sets](#1-identify-the-target-save-sets)
  - [2. Prepare the SSID Command List](#2-prepare-the-ssid-command-list)
  - [3. Execute the NetWorker Commands](#3-execute-the-networker-commands)
  - [4. Check Data Domain Space](#4-check-data-domain-space)
  - [5. Start and Monitor Cleaning](#5-start-and-monitor-cleaning)
- [Validation and Recorded Evidence](#validation-and-recorded-evidence)
- [Repository Structure](#repository-structure)
- [References](#references)
- [Author and Original Publication](#author-and-original-publication)

## Safety Notice

> WARNING: This procedure includes destructive backup-deletion commands.
>
> Do not execute the examples without reviewing the target save sets, retention requirements, recovery dependencies, and documentation applicable to your environment.

Before proceeding:

- Obtain authorization to delete the selected backups.
- Verify every SSID against the intended backup.
- Confirm that the selected backups are no longer required for recovery.
- Review applicable retention, compliance, and data-protection requirements.
- Confirm the scope and behavior of each command for your installed versions.
- Review whether other backup copies or dependencies affect the intended operation.
- Use an approved maintenance window where required.

The examples include the `-y` option as used in the original procedure. Do not copy the commands into a production session without reviewing them.

This repository documents a historical community contribution. It is not an official Dell procedure, a compatibility guarantee, or a replacement for vendor documentation and support.

## Overview

The original workflow consists of the following steps:

```text
Identify the target save sets in NetWorker
                    |
                    v
Copy the SSIDs and prepare deletion commands
                    |
                    v
Execute the nsrmm commands on the NetWorker server
                    |
                    v
Run nsrim -X
                    |
                    v
Check filesystem space on Data Domain
                    |
                    v
Start and monitor filesystem cleaning
```

The procedure documents actions on both NetWorker and Data Domain. It should not be interpreted as a guarantee that deleting a particular logical backup size will recover the same amount of physical storage.

## Historical Environment

The original screenshots show the following software versions:

| Component | Version shown |
|---|---|
| NetWorker Administration | 19.1.0.2, Build 74 |
| Data Domain OS | 6.0.2.30-606339 |

The NetWorker commands were executed through an SSH session to a NetWorker Virtual Appliance. The Data Domain commands were executed in a separate SSH session.

These details describe the historical example. They do not establish support or compatibility for other releases or deployment types.

## Scope and Limitations

This document covers:

- Selecting save sets visible in NetWorker.
- Extracting their SSIDs.
- Preparing and executing the deletion commands used in the original post.
- Running `nsrim -X`.
- Checking Data Domain filesystem space.
- Starting and monitoring filesystem cleaning.

This document does not provide:

- A recovery procedure for a Data Domain system with zero available space.
- A method for locating orphaned data after save sets have already disappeared from the NetWorker media database.
- A guarantee of how much physical capacity will be recovered.
- Troubleshooting instructions for replication, snapshots, retention locks, or other conditions that may affect space reclamation.
- Evidence of the final amount reclaimed in the original example.

Although the original discussion title refers to already-deleted save sets, this particular contribution begins by selecting save sets still visible in NetWorker.

The original Data Domain screenshot shows 25% filesystem usage. Therefore, this example must not be presented as a tested procedure for a completely full filesystem.

## Prerequisites

Before using this workflow, confirm that you have:

- Authorized access to NetWorker Administration.
- Appropriate administrative access to the NetWorker server.
- Appropriate administrative access to Data Domain.
- An approved list of backups to delete.
- Documentation applicable to your NetWorker and DD OS versions.
- A location to record command output and before-and-after measurements.

The original workflow used Excel to prepare command lines. A spreadsheet is part of the documented example, not a requirement to automate execution.

## Procedure

### 1. Identify the Target Save Sets

In NetWorker Administration:

1. Open the **Media** section.
2. Select **Disk Volumes**.
3. Locate the relevant volume.
4. Open its context menu and select **Show Save Sets**.
5. Identify the backups intended for deletion.
6. Review the **SSID** column and the associated backup details.

Select only the save sets covered by the approved deletion request.

Suggested screenshot location:

```text
docs/images/01-networker-show-save-sets.jpg
```

Suggested screenshot location for the SSID selection:

```text
docs/images/02-networker-ssid-selection.jpg
```

### 2. Prepare the SSID Command List

The original procedure used the following approach:

1. Select the target save sets.
2. Press `Ctrl+C`.
3. Paste the copied rows into Excel.
4. Keep the column containing the SSIDs.
5. Build one command line per approved SSID.

Command template:

```bash
nsrmm -d -S <SSID> -y
```

Replace `<SSID>` with the reviewed identifier. Do not type the angle brackets.

For documentation and review, the prepared list should look like this:

```text
nsrmm -d -S <APPROVED_SSID_1> -y
nsrmm -d -S <APPROVED_SSID_2> -y
nsrmm -d -S <APPROVED_SSID_3> -y
```

These are templates, not ready-to-run commands.

Before execution, review the complete list and check for:

- Incorrect SSIDs.
- Duplicate entries.
- Missing or truncated digits.
- Unexpected spreadsheet formatting.
- Backups outside the approved deletion scope.

Suggested screenshot location:

```text
docs/images/03-command-preparation.jpg
```

### 3. Execute the NetWorker Commands

Open an authorized administrative session to the appropriate NetWorker server.

In the original example, this was an SSH session to the NetWorker Virtual Appliance.

Execute the reviewed `nsrmm` commands:

```bash
nsrmm -d -S <SSID> -y
```

Record the command output and investigate any errors before continuing.

After executing the deletion commands, the original procedure runs:

```bash
nsrim -X
```

This command is included here to preserve the sequence documented in the original post. Review its purpose, scope, and applicable vendor guidance for your installed release before running it.

Suggested screenshot location:

```text
docs/images/04-networker-cli.jpg
```

### 4. Check Data Domain Space

Open a separate administrative SSH session to Data Domain.

Run:

```bash
filesys show space
```

Record the output before starting cleaning.

The original screenshot contains these values:

| Metric | Recorded value |
|---|---:|
| `/data: post-comp` size | 3757.6 GiB |
| Used space | 952.3 GiB |
| Available space | 2805.3 GiB |
| Usage | 25% |
| Cleanable space | 136.1 GiB |

The output labels the cleanable value as an estimate based on the last cleaning.

The displayed 136.1 GiB must not be reported as the amount actually reclaimed by the subsequent cleaning operation.

### 5. Start and Monitor Cleaning

After completing the applicable reviews and confirming that cleaning is appropriate for the environment, start it with:

```bash
filesys clean start
```

Monitor its progress with:

```bash
filesys clean watch
```

The original screenshot shows the following confirmation:

```text
Cleaning started. Use 'filesys clean watch' to monitor progress.
```

The original post notes that completion can take hours. Do not treat that observation as a guaranteed duration for another system.

Once cleaning has completed, collect a new space report:

```bash
filesys show space
```

This final measurement is a recommended documentation step for new executions. A post-cleaning space report was not included in the original screenshots.

Suggested screenshot location:

```text
docs/images/05-datadomain-cleaning.jpg
```

## Validation and Recorded Evidence

The original screenshots document:

- The NetWorker volume and save-set selection interface.
- The SSID column used to identify the selected backups.
- A spreadsheet containing prepared command lines.
- Execution of the `nsrmm` command sequence.
- The subsequent `nsrim -X` command.
- Data Domain filesystem space before cleaning.
- Confirmation that Data Domain cleaning started.

They do not establish:

- Successful completion of the entire cleaning operation.
- The exact amount of physical storage recovered.
- A before-and-after comparison.
- The applicability of the procedure to a completely full Data Domain filesystem.

For a new execution, record the following:

| Item | Before | After |
|---|---|---|
| Measurement timestamp | Record value | Record value |
| Used GiB | Record value | Record value |
| Available GiB | Record value | Record value |
| Cleanable GiB | Record value | Record value |
| Cleaning status | Record status | Record status |

Also document any backup ingestion or other activity occurring between measurements. Avoid attributing all capacity changes to cleaning without considering concurrent activity.

## Repository Structure

```text
networker-datadomain-space-reclamation/
├── README.md
├── README.pt-BR.md
├── CHANGELOG.md
└── docs/
    ├── original-post.md
    ├── references.md
    └── images/
        ├── 01-networker-show-save-sets.jpg
        ├── 02-networker-ssid-selection.jpg
        ├── 03-command-preparation.jpg
        ├── 04-networker-cli.jpg
        └── 05-datadomain-cleaning.jpg
```

The image paths above are suggested filenames. Add the reviewed and sanitized screenshots to those locations before inserting image links.

Remove or redact internal identifiers before publishing, including hostnames, addresses, customer information, and infrastructure names.

## References

### Original Dell Community Discussion

[How to free space on Data Domain for already-deleted save sets from NetWorker database — original contribution by RodrickNunes](https://www.dell.com/community/en/conversations/networker/how-to-free-space-on-data-domain-for-allready-deleted-save-sets-from-networker-database/647f6ef4f4ccf8a8dec565d6?commentId=647f8e4df4ccf8a8def23366)

### Related Dell Knowledge Base Articles

The following articles are provided for further review. Their inclusion does not imply that every step in this historical workflow is applicable to every scenario they describe.

- [Dell KB 000054303 — Data Domain: como resolver o alto consumo de espaço ou a baixa capacidade disponível](https://www.dell.com/support/kbdoc/pt-br/000054303/data-domain-como-resolver-o-alto-consumo-de-espa%C3%A7o-ou-a-baixa-capacidade-dispon%C3%ADvel)
- [Dell KB 000015007 — Data Domain: Cleaning Not Recovering Disk Space](https://www.dell.com/support/kbdoc/en-us/000015007/71716-cleaning-not-recovering-disk-space)
- [Dell KB 000346279 — Data Domain: Zero Available Space in File System (/data)](https://www.dell.com/support/kbdoc/en-us/000346279/data-domain-0-available-space-in-file-system-data)

Consult the current vendor documentation before applying the procedure to another environment.

## Author and Original Publication

- Author: Rodrigo N. S. Fernandes
- Dell Community username: RodrickNunes
- Original publication date: November 28, 2020
- Original platform: Dell Community

This repository organizes the original contribution into a reusable technical document while distinguishing historical evidence from recommendations for future executions.

NetWorker, Data Domain, and Dell product names are used for identification. This project is independent and is not affiliated with or endorsed by Dell Technologies.
