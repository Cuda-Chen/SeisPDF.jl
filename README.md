
| **Build Status** | **Documentation** |
| :---: | :---: |
| [![][action-img]][action-url] | [![][docs-latest-img]][docs-latest-url] |

# SeisPDF.jl
Power Spectral Density Probability Density Functions Calculation
described by [McNamara 2004](https://pubs.usgs.gov/of/2005/1438/).

## TO-DO
- [x] release workable version
    - [x] plot (using GMT.jl)
    - [x] integrate with [SeisIO](https://github.com/jpjones76/SeisIO.jl) data structure
    - [x] slide on actual timestamp range
- [ ] GPU support
    - [ ] CUDA
    - [ ] AMD (optional)
- [ ] enhancements
    - [x] docs
    - [ ] swappable FFT libraries (e.g., kissFFT)
    - [ ] min, max, mode PDF
    - [ ] read high and low noise model into memory when importing

<!-- URLS -->
[action-img]: https://github.com/Cuda-Chen/SeisPDF.jl/workflows/CI/badge.svg
[action-url]: https://github.com/Cuda-Chen/SeisPDF.jl/actions/workflows/ci.yml
[docs-latest-img]: https://github.com/Cuda-Chen/SeisPDF.jl/workflows/docs/badge.svg
[docs-latest-url]: https://cuda-chen.github.io/SeisPDF.jl/
