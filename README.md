# 📚 LaTeX-Cookbook

This repository contains a custom LaTeX-based system for compiling a beautifully formatted cookbook from modular recipe files.

Each recipe is written in its own `.tex` file and assembled into a complete PDF cookbook using GitHub Actions.

---

## 📖 How It Works

- Recipes are written as individual `.tex` files in the `recipes/` folder using a custom `recipebook` document class.
- The `main.tex` file assembles everything using `\input`.
- PDF builds are automated with GitHub Actions (`build-pdf.yml`).
- Artifacts like processed images and class files are managed and uploaded via workflows.
- The final PDF is automatically released using `release.yml`.


## ✅ Features

- Modular recipe files
- Automatic PDF generation via GitHub Actions
- Versioned GitHub Releases with PDF download
- Custom `recipebook` LaTeX class

---

## 📌 TODOs & Improvements

- [ ] **Improve Table of Contents (`toc.tex`)**
- [ ] **Redesign `titlepage.tex`**
- [ ] **Auto-include recipes**
- [ ] **Localization**

## License

Distributed under the MIT License. See `LICENSE.txt` for more information.
