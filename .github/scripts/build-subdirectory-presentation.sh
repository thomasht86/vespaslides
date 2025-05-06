#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

# Directory containing your presentation subfolders (e.g., presentations/my-talk/slides.md)
PRESENTATIONS_DIR="presentations"

if [ ! -d "${PRESENTATIONS_DIR}" ]; then
  echo "Directory ${PRESENTATIONS_DIR} not found. Skipping subdirectory presentations."
  # Exiting with 0 so the workflow doesn't fail if this directory is optional
  exit 0
fi

echo "Looking for presentations in ./${PRESENTATIONS_DIR} ..."
# Loop through each immediate subdirectory in PRESENTATIONS_DIR
# Uses find ... -print0 and while read -d $'\0' for robustness with special characters in folder names
find "${PRESENTATIONS_DIR}" -mindepth 1 -maxdepth 1 -type d -print0 | while IFS= read -r -d $'\0' presentation_folder_path; do
  # Extracts the folder name (e.g., "2025-07-05-ai-teknologi") to use as a slug
  presentation_slug=$(basename "${presentation_folder_path}")
  slide_file_path="${presentation_folder_path}/slides.md"

  if [ -f "${slide_file_path}" ]; then
    echo "--------------------------------------------------"
    echo "Building presentation: ${presentation_slug}"
    echo "Source file: ${slide_file_path}"

    # Base path for subdirectory presentations: /<repository-name>/<slug>/
    # GH_PAGES_REPO_NAME is expected to be set in the environment by the GitHub Actions workflow
    BASE_PATH="/${GH_PAGES_REPO_NAME}/${presentation_slug}/"
    # Output to a subfolder within 'dist' named after the slug
    OUTPUT_DIR="./dist/${presentation_slug}"

    echo "Calculated SUBDIR BASE_PATH: ${BASE_PATH}"
    echo "Subdir Output directory: ${OUTPUT_DIR}"

    # Ensure the specific output directory for the presentation exists
    mkdir -p "${OUTPUT_DIR}"

    # Assumes your package.json has "build": "slidev build"
    # nr runs: slidev build path/to/slides.md --base "/<repo-name>/<slug>/" --out "./dist/<slug>"
    nr build "${slide_file_path}" --base "${BASE_PATH}" --out "${OUTPUT_DIR}"
    echo "Build for ${presentation_slug} complete."
  else
    echo "--------------------------------------------------"
    echo "No slides.md found in ${presentation_folder_path}. Skipping this folder."
  fi
done
echo "--------------------------------------------------"
echo "Subdirectory presentation builds finished."