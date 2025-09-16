<img src="http://tech-away.co.za/images/github-dockyard/dockyard-logo.jpg" />

# 🛳️ Dockyard

> **🎯TODO** <br> Wrap the badges in an HTML/CSS container!

![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white)

![Docker Image Size (tag)](https://img.shields.io/docker/image-size/thedevstallion96/dockyard/latest)

![GitHub labels](https://img.shields.io/github/labels/TheDevStallion96/dockyard/Learning?style=plastic)

![Linux](https://img.shields.io/badge/Linux-white?style=for-the-badge&logo=linux&logoColor=080530)

![Linux](https://img.shields.io/badge/Linux-white?style=plastic&logo=linux&logoColor=080530)

Welcome aboard, traveler! **Dockyard** is my personal shipyard ⚓ where I forge, customize, and stash Docker images for my home lab adventures. Think of it as a weird mix between a pirate cove 🏴‍☠️ and a CI/CD pipeline that had too much ☕.

---

## 🐳 What is Dockyard?
Dockyard is **not** your average “Hello World” collection of Dockerfiles. Nope.  
It’s a **personal fleet** of handcrafted, slightly opinionated, and occasionally over-engineered Docker images designed to make my homelab life easier.  

Whether it’s for development, tinkering, or running services I probably don’t need (but *want* anyway), Dockyard is where these containers get built, christened, and launched. 🚢

---

## ✨ Features (aka: Why this repo exists)

- 🔧 **Custom-built images** for my homelab services.  
- 📦 **Reusable Dockerfiles** so I don’t reinvent the wheel (again).  
- 🧪 **Experimental builds** because “what if…” is basically my default mode.  
- 🤓 **Nerdy naming conventions** and questionable code comments included at no extra charge.  
- 🐙 **GitHub + Docker synergy** that feels like DevOps cosplay.  

---

## 🧭 Usage (Captain’s Orders)

Clone the repo and set sail:
```bash
git clone https://github.com/TheDevStallion96/dockyard.git
cd dockyard
````

Build an image from one of the directories:

```bash
docker build -t my-custom-image ./path/to/dockerfile
```

Then run it like the captain you are:

```bash
docker run -d --name my-container my-custom-image
```

⚠️ Disclaimer: If it sinks, you’re the captain now. 🫡

---

## ⚓ Repo Structure

```dockyard/
├── README.md                  
├── CONTRIBUTING.md
├── LICENSE
├── ubuntu-base/
│   ├── Dockerfile              
│   ├── config/
│   │   └── sources.list
│   ├── docs/
│   │   └── README.md
│   ├── scripts/
│   │   └── entrypoint.sh
│   └── tests/
│       └── test.sh
```

---

## 🤔 FAQ (Frequently Asked Quirks)

**Q:** Why not just pull official images?
**A:** Because I like pain, control, and YAML-induced rage.

**Q:** Will these images work for me?
**A:** Maybe. Probably. If not, just remember: *works on my machine™*.

**Q:** Is this production-ready?
**A:** Absolutely not. Unless your production is a Raspberry Pi under your desk.

> ⚠️ **WARNING**: These images are NOT production-ready or public facing, they are purely for my home lab.

---

## 🧑‍💻 Contributing

This is a personal playground, but if you somehow ended up here and feel like contributing:

* Open a PR.
* Add memes in your commit messages.
* Bonus points for nautical puns.

---

## 📜 License

MIT — because open-source pirates share their loot. 🏴‍☠️

---

## 🐙 Closing Thoughts

If Docker is the ship, and containers are the crew, then Dockyard is the place where I keep yelling at them until they behave.

# Welcome to my fleet. 🚀⚓🐳
