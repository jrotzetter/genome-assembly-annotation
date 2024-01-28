# *A. thaliana* genome assembly and annotation

[![GitHub tag](https://img.shields.io/github/tag/JeremyRotzetter/genome-assembly-annotation?include_prereleases=&sort=semver&color=blue)](https://github.com/JeremyRotzetter/genome-assembly-annotation/releases/)
[![License](https://img.shields.io/badge/License-GPLv3-blue)](#license)
[![issues - genome-assembly-annotation](https://img.shields.io/github/issues/JeremyRotzetter/genome-assembly-annotation)](https://github.com/JeremyRotzetter/genome-assembly-annotation/issues)

## Introduction
The work presented here was carried out in the autumn semester of 2023 for the *Genome and Transcriptome Assembly* course at the University of Berne and the *Organization and Annotation of Eukaryotic Genomes* course at the University of Fribourg.

The project aimed to teach the students how to assemble genomes and transcriptomes, but also how to annotate the resulting assemblies. Further, it sought to assess the presence of synteny/ collinearity in five *Arabidopsis thaliana* subpopulations (An-1, C24, Cvi-0, Ler, and Sha). Raw sequencing data obtained from Jiao and Schneeberger (2020)[^1]. More information is available [here](https://www.nature.com/articles/s41467-020-14779-y#data-availability).

The [**methods.md**](https://github.com/JeremyRotzetter/genome-assembly-annotation/methods.md) file broadly explains the steps taken during the project and also provides all tools, their utilized versions and where to obtain them.

## Repository structure
The repository is divided into an assembly and an annotation part.
- [assembly](assembly) folder: contains all the scripts used in the genome and transcriptome assembly. The logical order in which they should be executed is given by their respective numbering.
- [annotation](annotation) folder: contains all the scripts used in the genome annotation. The logical order in which they should be executed is given by their respective numbering.

## License
Released under [GNU GPLv3](https://choosealicense.com/licenses/gpl-3.0/) by [@JeremyRotzetter](https://github.com/JeremyRotzetter).

This license means:
- You can freely copy, modify, distribute and reuse this software.
- The _original license_ must be included with copies of this software.
- Please _link back_ to this repo if you use a significant portion of the source code.
- The software is provided "as is", without warranty of any kind.
- Source code must be made available when this software is distributed.

[^1]: Jiao WB, Schneeberger K. Chromosome-level assemblies of multiple Arabidopsis genomes reveal hotspots of rearrangements with altered evolutionary dynamics. Nat Commun. 2020;11(1):989. Published 2020 Feb 20. doi:10.1038/s41467-020-14779-y
