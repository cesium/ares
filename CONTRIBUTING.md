# 🚀 Getting Started

These instructions will get you a copy of the project up and running on your
local machine for development and testing purposes.

## 🔧 Commands

First, clone the repository:

```
git clone git@github.com:cesium/ares.git
cd ares
```

Then all the commands you'll need to start developing are here:
| Command | Action |
| :--------------------- | :------------------------------------------------ |
| `npm install` | Install dependencies |
| `npm run dev` | Start local dev server at `localhost:4321` |
| `npm run build` | Build your production site to `./dist/` |
| `npm run preview` | Preview your build locally, before deploying |
| `npm run astro ...` | Run CLI commands like `astro add`, `astro check` |
| `npm run astro --help` | Get help using the Astro CLI |
| `npm run format` | Format code with [Prettier](https://prettier.io/) |
| `npm run clean` | Remove `node_modules` and build output |

## 🔼 Opening a PR

### Previewing your work

To preview your amazing work, run Ares (`npm run dev`) and open your page. It should be in http://localhost:4321/.

After you are done writing, commit your changes to your branch and push.

```
git add *your changed files*
git commit -m "Your commit message"
git push
```

Now all that is left to do is opening a Pull Request so your contribution can be published into production. If you don't know how to open a Pull Request, please refer to [this guide](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request). **_Don't forget to select the reviewers_**.
Once your PR is approved, your commit will be pushed to main and to production. Congratulations, you just contributed to the Ares repository.

### Note for those not a part of the CeSIUM team

If you are not a member of our team on Github, then instead of creating a branch you need to fork this project. If you don't know how to do that, please [refer to this guide](https://docs.github.com/en/get-started/quickstart/fork-a-repo).
