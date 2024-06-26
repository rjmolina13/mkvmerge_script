<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>

<img src="https://moe-counter.glitch.me/get/@:rjmolina13" alt="Image" width="140" height="40">

<!-- PROJECT SHIELDS -->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
<!-- [![Visitors][Visitors]][Visitors-url] -->





<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/rjmolina13/mkvmerge_script">
    <img src="images/logo.png" alt="Logo" width="300" height=45>
  </a>

## <div style="text-align: center">mkvmerge_script <span style="font-size: 0.7em; font-style: italic">*v6.1*</span></div>

<div align="center">
  <p>
    mkvmerge_script: a fast and efficient batch script that merges multiple <code>.mkv</code> files, <code>.ass</code> files, and/or <code>.xml</code> chapter files into a single MKV file using mkvmerge.
    <br />
    <br />
    <a href="https://github.com/rjmolina13/mkvmerge_script">View Demo</a>
    ·
    <a href="https://github.com/rjmolina13/mkvmerge_script/issues">Report Bug</a>
    ·
    <a href="https://github.com/rjmolina13/mkvmerge_script/issues">Request Feature</a>
  </p>
</div>

</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#setup--usage">Setup / Usage</a></li>
      </ul>
    </li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project

[![mkvmerge_script Screenshot][product-screenshot]](https://github.com/rjmolina13/mkvmerge_script#!)

***mkvmerge_script*** is a batch script that allows you to merge multiple `.mkv` files, `.ass` files, and/or `.xml` chapter files into a single MKV file using mkvmerge, a fast and efficient muxer.

This script simplifies the process of merging multiple files into a single `.mkv` file by automating the process. You no longer have to manually run mkvmerge for each file and keep track of the order of files to merge. Just add your `.mkv` files, `.ass` files, and/or `.xml` chapter files to the same folder and run the script.

***mkvmerge_script*** will scan the folder for all the files and merge them into a single MKV file in the correct order, with the subtitles and chapters properly aligned. 

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

* [![Batch][Shell]][Shell-url]
* [![Love][Love]][Love-url]


<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- GETTING STARTED -->
## Getting Started

To use mkvmerge_script, download and place mkvmerge.exe and ffprobe.exe in the bin folder at the root directory, and then run the batch script. Do follow the prerequisites and instructions below.

### Setup / Usage

1. Clone the mkvmerge_script repository to your local machine or [download it from here](https://github.com/rjmolina13/mkvmerge_script/raw/main/mkvmerge_script.bat) (right click > save link as).
2. Place the batch script in a its own separate foldder.
3. Download the latest version of `mkvmerge` from https://mkvtoolnix.download/ and `ffprobe` from https://www.gyan.dev/ffmpeg/builds/ffmpeg-git-essentials.7z.
4. Extract the `mkvmerge.exe` file from the mkvtoolnix package and `ffprobe.exe` file from the ffmpeg package, place the two files in the bin folder (which you can either make or run the script once and it will make it for you) at the root directory of the script. 

    - Folder structure should be:

```
mkvmerge_script
.
|-- bin
|   |-- ffprobe.exe
|   `-- mkvmerge.exe
`-- mkvmerge_script.bat

1 directory, 3 files
```

1. Double-click on the batch script to run it.
2. Before you start, check your config/settings on the right side of the script window/terminal. 

<img align="center" src="images/readme_1.png" alt="Config" width="30%" height="30%">

7. Then input the path of the Show/`.mkv`s you want to process.

<img align="center" src="images/readme_2.png" alt="Path" width="55%" height="55%">

8. Finally, input the name of the show.

<img align="center" src="images/readme_3.png" alt="Path" width="55%" height="55%">

9. Wait for the script to finish muxing the files. *(Tip: It will play a sound to let you know that it has finished.)*
10. It will ask you if you want to delete the source file and move the processed files to replace the source files. You may find the processed files on the path you have specified.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ROADMAP -->
## Roadmap

- [x] Implement wget auto download for prereqs
- [x] Implement auto extraction of downloaded prereqs
- [ ] Make python version -- to achieve cross-OS compatibility

See the [open issues](https://github.com/rjmolina13/mkvmerge_script/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/NewFeature`)
3. Commit your Changes (`git commit -m 'Add some NewFeature'`)
4. Push to the Branch (`git push origin feature/NewFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- LICENSE -->
## License

This project is licensed under the terms of the GNU General Public License v3.0. See `LICENSE.txt` for more information.

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

@rjmolina13 - [@rjmolina13](https://twitter.com/rjmolina13) - rj.molina13.2@gmail.com

Project Link: [https://github.com/rjmolina13/mkvmerge_script](https://github.com/rjmolina13/mkvmerge_script)

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- ACKNOWLEDGMENTS -->
## Acknowledgments


- This project uses the mkvmerge utility from mkvtoolnix (https://mkvtoolnix.download/) and the ffprobe utility from ffmpeg (https://ffmpeg.org/).
- This project was inspired by the need to quickly and easily process multiple `.mkv` and `.ass` files into a each single file.


<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[Visitors]: https://moe-counter.glitch.me/get/@:rjmolina13
[Visitors-url]: https://github.com/rjmolina13/mkvmerge_script#!
[Shell]: https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white
[Shell-url]: https://github.com/rjmolina13/mkvmerge_script#!
[Love]: https://img.shields.io/badge/love-%E2%9D%A4%EF%B8%8F-black?style=for-the-badge
[Love-url]: https://github.com/rjmolina13/mkvmerge_script#!
[contributors-shield]: https://img.shields.io/github/contributors/rjmolina13/mkvmerge_script.svg?style=for-the-badge
[contributors-url]: https://github.com/rjmolina13/mkvmerge_script/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/rjmolina13/mkvmerge_script.svg?style=for-the-badge
[forks-url]: https://github.com/rjmolina13/mkvmerge_script/network/members
[stars-shield]: https://img.shields.io/github/stars/rjmolina13/mkvmerge_script.svg?style=for-the-badge
[stars-url]: https://github.com/rjmolina13/mkvmerge_script/stargazers
[issues-shield]: https://img.shields.io/github/issues/rjmolina13/mkvmerge_script.svg?style=for-the-badge
[issues-url]: https://github.com/rjmolina13/mkvmerge_script/issues
[license-shield]: https://img.shields.io/github/license/rjmolina13/mkvmerge_script.svg?style=for-the-badge
[license-url]: https://github.com/rjmolina13/mkvmerge_script/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[product-screenshot]: images/screenshot.png

