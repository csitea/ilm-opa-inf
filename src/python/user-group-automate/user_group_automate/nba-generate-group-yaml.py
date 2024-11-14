import pandas as pd
import yaml
from pathlib import Path


# If more sheets added to excel, they need to be added here
org_app_sheet_names = [
    "ilm-opa-dev",
    "ilm-opa-stg",
    "ilm-opa-tst"
]

groups_to_role_mapping = {
    "aws_iam_role_auditors": "auditors",
    "aws_iam_role_be_developers": "be_developers",
    "aws_iam_role_cicd_backend": "cicd_backend",
    "aws_iam_role_cicd_ui": "cicd_ui",
    "aws_iam_role_data_scientists": "data_scientists",
    "aws_iam_role_developers": "developers",
    "aws_iam_role_devops": "devops",
    "aws_iam_role_fe_developers": "fe_developers",
    "aws_iam_role_infra_admins": "infra_admins"
}

# Read Infrastructure yaml
path_to_app_yaml = Path("/opt/spe/spe-infra-conf/nba/all/006-individual-users/users.yaml").expanduser()
with open(path_to_app_yaml, "r") as file:
    app_user_group_yaml = yaml.safe_load(file)

# Read Excel file for sheets set above
path_to_excel = Path("/opt/spe/spe-infra-conf/iam/xls/AWS IAM roles for NGI.xlsx").expanduser()
org_app_workbook = pd.read_excel(path_to_excel, org_app_sheet_names, true_values=["x"])

def generate_group_name_list(sheet, role_name_list):
    new_list=[]
    for role_name in role_name_list:
        group_name_prefix = sheet.replace("-", "_")
        group_name_suffix = groups_to_role_mapping[role_name]
        group_name = group_name_prefix + "_" + group_name_suffix
        new_list.append(group_name)
    return new_list

def generate_role_list_for_user(sheet_name, sheet_user_email):
    user_roles = []
    # Iterate through all columns for each row
    for user_column_value in org_app_workbook[sheet_name].loc[org_app_workbook[sheet_name]["EmailAddress"] == sheet_user_email].iloc[0].items():
        # If key is in list then continue in loop
        if user_column_value[0] in ["PersonName", "EmailAddress", "rtr_adm"]:
            continue
        # If key is Offboarded and value is True then set user_roles to empty and break
        if user_column_value[0] == "Offboarded" and user_column_value[1] == True:
            user_roles = []
            break
        # If any other key and value is true then append role to list
        if user_column_value[1] == True:
            user_roles.append(user_column_value[0])
    return user_roles


# Create email list from existing YAMLs
app_yaml_email_list=[]
for obj in app_user_group_yaml:
    app_yaml_email_list.append(obj["username"])

# List for the output YAML
app_user_group_yaml_updated = []

# Add old yaml with empty groups to output YAML
for email in app_yaml_email_list:
    app_user_group_yaml_updated.append({"username": email, "groups": []})

# Iterate through sheets
for sheet_name in org_app_sheet_names:
    print(f"Working on sheet: {sheet_name}")

    # Get list of all emails in sheet under work
    sheet_email_list = org_app_workbook[sheet_name]["EmailAddress"].to_list()

    # Iterate through all emails in sheet
    for sheet_user_email in sheet_email_list:
        user_roles = generate_role_list_for_user(sheet_name, sheet_user_email)
        user_groups = generate_group_name_list(sheet_name, user_roles)

        # If processing email not found in output YAML, add it with empty group
        if sheet_user_email not in [d["username"] for d in app_user_group_yaml_updated]:
            app_user_group_yaml_updated.append({"username": sheet_user_email, "groups": []})

        # Iterate through users in updated YAML
        for user in app_user_group_yaml_updated:
            # If user in updated YAML matches the email being processed
            if user["username"] == sheet_user_email:
                # If groups list is empty use generated groups
                if not user["groups"]:
                    user["groups"] = user_groups
                # If group list not empty, append unique groups
                else:
                    for user_group in user_groups:
                        if user_group not in user["groups"]:
                            user["groups"].append(user_group)


# Write to file
path_to_write = Path("/opt/spe/spe-infra-conf/nba/all/006-individual-users/users-new.yaml").expanduser()
with open(path_to_write, 'w') as file:
    documents = yaml.dump(app_user_group_yaml_updated, file)
