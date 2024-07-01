# QuickStart

## Introduction

This quickstart uses OpenTofu (Tofu, a Terraform alternative) to automatically deploy many services into Google Cloud. This includes a Backend API service, HTTPS TLS/SSL certificates, a CDN website hosted in a Google Storage Bucket, and necessary supporting services.

## Video

You can watch the QuickStart Video (Coming Soon) to see the entire setup process.

## Create Project

1. Go to [Google Cloud Console - Resource Manager](https://console.cloud.google.com/cloud-resource-manager)
1. Click "Create Project" in top menu bar
1. Pick and type a "Project ID" (this cannot be changed later!)
1. Go to the [Google Cloud Console - Welcome Page](https://console.cloud.google.com/welcome)
1. Ensure your project is selected on the top-left dropdown
1. Take note of your project name (this is called your "Project ID")
1. Use the Google Cloud Shell (top right terminal icon) to get your "Project Number" for later with the command below

```bash
# Set your Project ID in Google Cloud Shell
gcloud config set project TYPEPROJECTIDHERE

# Shows your Project Number
gcloud projects list --filter="$(gcloud config get-value project)" --format="value(PROJECT_NUMBER)"

# Enables checking for services later on (run while you're here)
gcloud services enable serviceusage.googleapis.com
```

## Create CLI Service Account

1. Go to [IAM and Admin => Service Accounts](https://console.cloud.google.com/iam-admin/serviceaccounts)
1. Click "Create Service Account" button in the top bar
1. Set "Service account name" to "cli"
1. Leave "Service account ID" at the generated value, change it if you want
1. Add a "Service account description" if you want
1. Click "Create and Continue" button
1. "Select a Role" and filter for "Owner"
1. WARNING: this key should be temporary as it will have full access to your Google Cloud account. See below "Removing CLI Access"
1. Click "Continue"
1. Skip the final section and click "Done"
1. Make note of your "Service account ID" for later

## Create CLI Key

1. Click the "three dots" menu icon on the right of cli service account
1. Click "Manage Keys"
1. Click "Add Key"
1. Click "Create new key"
1. Select "JSON"
1. Click "Create"
1. A new JSON file will be downloaded to your computer
1. WARNING: Keep this file secret as it allows full access to your Google Cloud Account

## Verify Domain in Google Search Console

1. Visit [Google Search Console](https://search.google.com/search-console)
1. Login to your account (You can use a personal Gmail or company GSuite account)
1. Double-check the account you're using to ensure it's the desired one
1. In the top-left dropdown, either add your property (domain name) or select it
1. In the left sidebar, scroll down to "Settings"
1. Select "Users and Permissions"
1. Click "Add User"
1. Input `SERVICEACCOUNTID@PROJECTID.iam.gserviceaccount.com` as the email, replacing with your Service Account ID and Project ID
1. Select "Owner" access permission
1. Click "Add"

## Install OpenTofu (Terraform)

1. You can visit the [OpenTofu Website](https://opentofu.org/) for more details
1. For macOS, use [Homebrew](https://brew.sh/) and run `brew install opentofu`
1. For Windows, you can download from the website or use [Chocolatey](https://chocolatey.org/) to run `choco install opentofu`
1. For Linux, check your repos or look at the [Install Page](https://opentofu.org/docs/intro/install/)
1. Verify installation with `tofu -v`

## Initialize Tofu and Enable GCP Services

1. Move the downloaded JSON key file (above) to this project directory (root, main folder)
1. Open `variables_general.tf` and edit "credentials_file" to match your key file name
1. Edit the "Project ID" and "Project Number" values as well
1. Review and edit the rest of the `variables_` files to suit your needs, such as domains
1. Run Tofu commands below

```bash
# Remember to change into this project's directory
tofu init -upgrade;
tofu apply -target="google_project_service.essential" -auto-approve
tofu apply -target="google_project_service.general" -auto-approve
```

## Connecting Code Repositories (GitHub)

1. Go to [Cloud Build => Repositories](https://console.cloud.google.com/cloud-build/repositories/2nd-gen)
1. Click "Create Host Connection" in the top menu bar
1. Ensure "GitHub" (not "GitHub Enterprise") is selected in the left sidebar
1. Select the same region your deployment will be in (default is us-central1)
1. Set the name to "github"
1. Click "Connect" button
1. Click "Install in New Account" button
1. Select your GitHub account that contains the fork of the boilerplate repos (and you MUST be using YOUR own forks! otherwise you cannot edit code and deploys will be unpredictable. Don't skip creating a FORK of these repos)
1. Select individual repos you want to add. Allowing access to all repositories is not recommended
1. Click "Install"
1. If you ever want to change this access you can either [Edit Allowed Repos and Settings](https://github.com/settings/installations) or [Revoke Access](https://github.com/settings/apps/authorizations)

## Creating Resources Automatically with Tofu

**NOTE!** Some resources will fail. In particular, the Backend API cannot run without first having a container image built with the pipeline. So don't worry about errors on the first run.

```bash
tofu apply;
# An error will occur and is expected this one time
# Error waiting to create Service: Error waiting for Creating Service: Error code 13
```

1. Run the [Backend API Pipeline](https://console.cloud.google.com/cloud-build/triggers) 1. Monitor progress in [Cloud Build - History](https://console.cloud.google.com/cloud-build/builds)
1. Once completed, run `tofu apply` again and you should not have an error this time

## Time Sensitive - Adding DNS Records

Please do these steps urgently and understand it can take multiple hours for the certificates to generate. Be very careful removing certificates in your config files because of how long they take to generate. If you prefer more control at the expense of convenience, you can manually generate and supply your certificates and keys within GCP and anywhere else you need, but that is an advanced use case. This will work fine for most cases.

1. Get your [IP Address](https://console.cloud.google.com/networking/addresses/list)
1. Add DNS records (A or for advanced users, CNAMEs can be used) for your CDN subdomain and Files subdomain set to your IP
1. Add DNS record (CNAME) for the API subdomain set to `ghs.googlehosted.com`
1. This will allow your TLS/SSL certificates to be generated. Keep an eye on them in [Certificate Manager - Classic](https://console.cloud.google.com/security/ccm/list/lbCertificates)

## Removing CLI Access

It is recommended to remove at least the generated key file from the CLI service account.  
You can also remove the entire service account but that will change its IDs.  
Instead, by removing the key, you can regenerate a key if you need one in the future with fewer steps to run the CLI again

1. Go to [IAM Service Accounts](https://console.cloud.google.com/iam-admin/serviceaccounts)
1. Either remove the entire "cli" service account or use the "three dots" menu to go into the key area and delete the key
