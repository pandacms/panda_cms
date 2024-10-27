export class ResourceLoader {
  static loadScript(frameDocument, head, src) {
    return new Promise((resolve, reject) => {
      const script = frameDocument.createElement("script")
      script.src = src
      head.append(script)

      script.onload = () => {
        console.debug(`[Panda CMS] Script loaded: ${src}`)
        resolve(script)
      }
      script.onerror = () => reject(new Error(`[Panda CMS] Script load error for ${src}`))
    })
  }

  static importScript(frameDocument, head, module, src) {
    return new Promise((resolve, reject) => {
      const script = frameDocument.createElement("script")
      script.type = "module"
      script.textContent = `import ${module} from "${src}"`
      head.append(script)

      script.onload = () => {
        console.debug(`[Panda CMS] Module script loaded: ${src}`)
        resolve(script)
      }
      script.onerror = () => reject(new Error(`[Panda CMS] Module script load error for ${src}`))
    })
  }

  static embedScript(description, frameDocument, head, code) {
    return new Promise((resolve) => {
      const script = frameDocument.createElement("script")
      script.textContent = code
      head.append(script)
      resolve(script)
      console.debug(`[Panda CMS] Embedded script loaded (${description})`)
    })
  }

  static loadStylesheet(frameDocument, head, href) {
    return new Promise((resolve, reject) => {
      const link = frameDocument.createElement("link")
      link.rel = "stylesheet"
      link.href = href
      link.media = "none"
      head.append(link)

      link.onload = () => {
        if (link.media != "all") {
          link.media = "all"
        }
        console.debug(`[Panda CMS] Stylesheet loaded: ${href}`)
        resolve(link)
      }
      link.onerror = () => reject(new Error(`[Panda CMS] Stylesheet load error for ${href}`))
    })
  }

  static embedCSS(frameDocument, head, css) {
    return new Promise((resolve) => {
      const style = frameDocument.createElement("style")
      style.textContent = css
      head.append(style)
      console.debug(`[Panda CMS] Embedded CSS loaded`)
      resolve(style)
    })
  }
}
