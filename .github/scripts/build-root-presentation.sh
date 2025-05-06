#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

if [ -f "slides.md" ]; then
  echo "Building root slides.md..."
  # GH_PAGES_REPO_NAME is expected to be set in the environment by the GitHub Actions workflow
  ROOT_BASE_PATH="/${GH_PAGES_REPO_NAME}/"
  # Output directly into the 'dist' folder
  ROOT_OUTPUT_DIR="./dist"

  echo "Input file: slides.md"
  echo "Calculated ROOT_BASE_PATH: ${ROOT_BASE_PATH}"
  echo "Output directory: ${ROOT_OUTPUT_DIR}"

  # Assumes your package.json has "build": "slidev build"
  # nr runs this script: slidev build slides.md --base "/<repo-name>/" --out "./dist"
  nr build slides.md --base "${ROOT_BASE_PATH}" --out "${ROOT_OUTPUT_DIR}"
  echo "Root presentation build complete."
else
  echo "No root slides.md found. Skipping root presentation build."
fi