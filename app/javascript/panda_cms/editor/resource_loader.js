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
}
