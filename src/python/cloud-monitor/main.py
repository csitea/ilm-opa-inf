import requests
import smtplib
import os
import sys
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from google.cloud import secretmanager

# List of URLs to check
URLS = [
    "http://csitea.net/appframe-premium-package",
    "http://csitea.net/appframe-premium-package",
    "http://csitea.net/appframe-premiumpaket",
    # "http://csitea.net/broken"
    # Add more URLs as needed
]

def access_secret_version(secret_id, version_id="latest"):
    """
    Fetch the secret value from Google Secret Manager.
    """
    client = secretmanager.SecretManagerServiceClient()
    project_id = os.getenv("GCP_PROJECT")  # Ensure GCP_PROJECT env is set

    # Build the resource name of the secret version.
    secret_name = f"projects/{project_id}/secrets/{secret_id}/versions/{version_id}"

    # Access the secret version.
    response = client.access_secret_version(name=secret_name)

    # Return the decoded secret payload.
    return response.payload.data.decode('UTF-8')


def check_urls_and_send_email(request=None):
    error_urls = []

    for url in URLS:
        print(f"Checking URL: {url}")
        try:
            response = requests.get(url, timeout=10)
            if response.status_code != 200:
                error_urls.append((url, response.status_code))
        except requests.RequestException as e:
            error_urls.append((url, str(e)))

    if error_urls:
        send_email_alert(error_urls)

    return "URL check complete."


def send_email_alert(error_urls):
    # Get the environment variables without fallback, and exit with an error if not found
    sender_email = os.getenv("SENDER_EMAIL")
    recipient_email = os.getenv("RECIPIENT_EMAIL")
    smtp_server = os.getenv("SMTP_SERVER")
    smtp_port = os.getenv("SMTP_PORT")
    smtp_username = os.getenv("SMTP_USERNAME")
    # Resolve variables from environment
    gcp_project = os.getenv("GCP_PROJECT")

    # Construct the secret ID dynamically
    secret_id = f"smtp-password-{gcp_project}"

    # Fetch SMTP password from Secret Manager
    smtp_password = access_secret_version(secret_id)

    # Check if all required environment variables are set
    if not all([sender_email, recipient_email, smtp_server, smtp_port, smtp_username, smtp_password]):
        sys.exit("Error: Required environment variables are not set. Please set SENDER_EMAIL, RECIPIENT_EMAIL, SMTP_SERVER, SMTP_PORT, SMTP_USERNAME, and SMTP_PASSWORD.")

    # Convert SMTP_PORT to int
    smtp_port = int(smtp_port)

    subject = f"{gcp_project}: URL Status Alert: Errors Found !!!"
    body = f"The following URLs returned errors:\n\n" + \
           "\n".join([f"{url}: {status}" for url, status in error_urls])

    msg = MIMEMultipart()
    msg['From'] = sender_email
    msg['To'] = recipient_email
    msg['Subject'] = subject
    msg.attach(MIMEText(body, 'plain'))

    try:
        with smtplib.SMTP(smtp_server, smtp_port) as server:
            server.starttls()
            server.login(smtp_username, smtp_password)
            server.sendmail(sender_email, recipient_email, msg.as_string())
    except Exception as e:
        print(f"Failed to send email: {e}")



def print_failing_urls(error_urls):
    print("The following URLs are failing:")
    for url, error in error_urls:
        print(f"{url} - {error}")

# For local testing, simply call the function without arguments
if __name__ == "__main__":
    check_urls_and_send_email()
