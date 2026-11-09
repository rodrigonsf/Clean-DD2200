# Original Dell Community Post

This document preserves the text of the procedure published by Rodrigo N. S. Fernandes, under the username RodrickNunes, in Dell Community.

## Publication Details

- Author: Rodrigo N. S. Fernandes
- Dell Community username: RodrickNunes
- Publication date displayed: November 28, 2020, 04:00
- Discussion title: How to free space on Data Domain for allready deleted save sets from NetWorker database
- [Original comment](https://www.dell.com/community/en/conversations/networker/how-to-free-space-on-data-domain-for-allready-deleted-save-sets-from-networker-database/647f6ef4f4ccf8a8dec565d6?commentId=647f8e4df4ccf8a8def23366)

## Editorial Note

The transcription below preserves the wording and command sequence shown in the original screenshots. Markdown formatting has been added for readability.

The screenshot inventory and historical limitations following the transcription are editorial additions, not part of the original post.

This file is a historical record, not a standalone recommendation to execute the commands. For safety considerations, scope, and limitations, consult [README.md](../README.md) or [README.pt-BR.md](../README.pt-BR.md).

## Original Text

### Step1:

On the Volume, left click to show the Save Sets and the SSIDs.

### Step2:

Select the backups you want to DELETE. You can select everything or just the ones you want.

After selecting, press CTRL + C and paste it into an excel table.

### Step3:

In excel, leave only the important column, which in this case is the column containing the SSID.

Than add the command lines that will be used in the CLI (`nsrmm -d -S "ssid" -y`)

### Step4:

Open a SSH connection to your NVA server and paste (at once) the list made in excel.

After run copied lines, run:

```text
nsrim -X
exit
```

### Step5:

Open a SSH connection to your DD server.

Use the command bellow to display the Cleanable space:

```text
filesys show space
```

Finally run the command bellow:

```text
filesys clean start
```

(This command can take a few hours to complete and can be accompanied with the `filesys clean watch` command.)

---

## Original Screenshot Inventory

The original contribution includes screenshots documenting the following stages.

| Stage | Content | Suggested repository file |
|---|---|---|
| Volume selection | NetWorker Administration with the `Show Save Sets...` context-menu option | `images/01-networker-show-save-sets.jpg` |
| SSID selection | Save-set list with the SSID column highlighted | `images/02-networker-ssid-selection.jpg` |
| Command preparation | Excel spreadsheet containing command components and SSIDs | `images/03-command-preparation.jpg` |
| NetWorker execution | SSH session showing the `nsrmm` commands and `nsrim -X` | `images/04-networker-cli.jpg` |
| Data Domain cleaning | SSH session showing `filesys show space` and the start of cleaning | `images/05-datadomain-cleaning.jpg` |

The filenames above are organizational suggestions for this repository, not filenames from the original publication.

Review and sanitize screenshots before publishing them. Preserve the technical evidence while removing confidential infrastructure details.

## Historical Environment Visible in the Screenshots

| Component | Version displayed |
|---|---|
| NetWorker Administration | 19.1.0.2, Build 74 |
| Data Domain OS | 6.0.2.30-606339 |

These versions identify the historical environment only. They do not establish compatibility with other releases.

## Data Domain Output Recorded in the Original Screenshot

The `filesys show space` output includes:

```text
Active Tier:

Resource          Size GiB   Used GiB   Avail GiB   Use%   Cleanable GiB*
----------------  --------   --------   ---------   ----   --------------
/data: pre-comp          -     8978.3           -      -                -
/data: post-comp    3757.6      952.3      2805.3     25%            136.1
/ddvar                49.2       10.0        36.7     22%                -
/ddvar/core           49.2        0.2        46.5      0%                -

* Estimated based on last cleaning of 2020/11/27 13:09:12.
```

After `filesys clean start`, the screenshot displays:

```text
Cleaning started. Use 'filesys clean watch' to monitor progress.
```

## Historical Limitations

The original screenshots record command execution and confirmation that Data Domain cleaning started.

They do not include:

- Confirmation that the entire cleaning operation completed.
- A post-cleaning space report.
- A verified amount of reclaimed physical capacity.
- A test of this procedure on a Data Domain filesystem with zero available space.

The displayed `Cleanable GiB` value of 136.1 is an estimate recorded before the new cleaning operation, not a measured result of that operation.

Although the discussion title refers to already-deleted save sets, this contribution begins by selecting save sets still visible in NetWorker.

## Relationship to the Repository Documentation

This file preserves the original contribution.

The repository README files organize that contribution into a broader technical document, with safety notices, prerequisites, explicit limitations, and recommendations for recording new executions.

Any future technical corrections or version-specific updates should be documented separately rather than silently incorporated into this historical transcription.
