
# ADSAC: Anchor-Guided Discriminative Subspace Alignment and Clustering for Cross-Scene Hyperspectral Imagery

> **AAAI 2026** | [Paper](https://ojs.aaai.org/index.php/AAAI/article/view/38295) | [Code](https://github.com/ZhangYongshan/ADSAC)

Official implementation of ADSAC, the first framework for cross-scene hyperspectral image (HSI) clustering without label guidance in either source or target scenes.

---
## Overview

Existing cross-scene HSI recognition methods rely heavily on labeled source data, which limits their applicability in real-world scenarios due to the high cost of pixel-level annotation. ADSAC removes this requirement entirely—**no labels are needed for either scene**.As illustrated in Fig. 1 (a), supervised methods perform cross-scene learning using fully labeled source data and partially labeled target data. In contrast, as shown in Fig. 1 (b), semi-supervised methods offer greater flexibility by requiring fully labeled source data and unlabeled target data for cross-scene learning . Their major difference lies in the labeling requirements of the target scene. Although existing methods show strong generalization performance, they always rely on fully labeled source data and either partially labeled or unlabeled target data. However, in practical scenarios, pixel-level annotation for HSIs is costly and time-consuming . The labeling requirement makes these methods inapplicable when explicit labels are unavailable for both source and target data. In such cases, as shown in Fig. 1 (c), cross-scene HSI clustering needs to be explored as a viable alternative.


<p align="center">
  <img src="assets/motivation.png" width="600"/>
  <br>
  <em>Figure 1: Comparison of cross-scene HSI recognition paradigms. ADSAC operates without labels in both source and target scenes.</em>
</p>

---

## Method

### Overall Framework

ADSAC follows a structured **three-stage learning paradigm**, as illustrated below:

<p align="center">
  <img src="assets/framework.png" width="800"/>
  <br>
  <em>Figure 2: Overall framework of ADSAC.</em>
</p>

ADSAC is built upon three core considerations: reliable source structure discovery, cross-scene discrepancy reduction, and effective knowledge transfer without label supervision. Accordingly, it adopts a concise three-stage pipeline:

- **Stage 1 (Anchor-Promoted Graph Learning)**: Perform anchor-guided source clustering to extract stable structural cues.  
- **Stage 2 (Cross-Scene Subspace Alignment)**: Learn aligned subspaces to reduce distribution shift while preserving discriminative and geometric properties.  
- **Stage 3 (Label Inference)**: Transfer knowledge from source to target to infer clustering labels in the aligned space.  

This design yields a fully unsupervised solution for cross-scene HSI clustering.

---

## Results

ADSAC is evaluated on **6 cross-scene clustering tasks** across three benchmark datasets and consistently outperforms 9 state-of-the-art methods.

<p align="center">
  <img src="assets/image.png" width="700"/>
  <br>
  <em>Figure 3: Quantitative comparison with state-of-the-art methods.</em>
</p>

---

## Datasets

| Dataset | Scenes | Size | Categories | Bands |
|---------|--------|------|-----------|-------|
| **Houston** | Houston2013, Houston2018 | 349×1905 | 7 | 48 |
| **Pavia** | Pavia Center, Pavia University | 1096×715 / 610×340 | 7 | 102 |
| **HyRANK** | Dioni, Loukia | 250×1376 / 249×945 | 12 | 176 |

---

## Getting Started

### Requirements

- MATLAB 2022b (ADSAC + shallow baselines)  
- Python 3.10 (deep baselines only)  

### Running ADSAC

```matlab
run main.m





