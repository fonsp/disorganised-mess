const myhash = async (s) => {
    const data = new TextEncoder().encode(s)
    const hashed_buffer = await window.crypto.subtle.digest("SHA-256", data)

    const base64url = await new Promise((r) => {
        const reader = new FileReader()
        reader.onload = () => r(reader.result)
        reader.readAsDataURL(new Blob([hashed_buffer]))
    })

    return base64url.split(",", 2)[1]
}
