import { useRef, useEffect } from 'react'
import * as THREE from 'three'

export default function Hero3D() {
  const mountRef = useRef<HTMLDivElement>(null)
  useEffect(() => {
    if (!mountRef.current) return
    const el = mountRef.current
    const scene = new THREE.Scene()
    scene.fog = new THREE.Fog(0x020617, 6, 22)
    const camera = new THREE.PerspectiveCamera(45, el.clientWidth / el.clientHeight, 0.1, 100)
    camera.position.set(4, 2.5, 6)
    camera.lookAt(0, 0, 0)
    const renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true })
    renderer.setSize(el.clientWidth, el.clientHeight)
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2))
    renderer.setClearColor(0x020617, 0)
    renderer.toneMapping = THREE.ACESFilmicToneMapping
    renderer.toneMappingExposure = 1.2
    el.appendChild(renderer.domElement)

    scene.add(new THREE.AmbientLight(0x334466, 0.4))
    const pl1 = new THREE.PointLight(0x00d4ff, 2, 30); pl1.position.set(5, 5, 5); scene.add(pl1)
    const pl2 = new THREE.PointLight(0xa855f7, 1, 30); pl2.position.set(-5, 3, -5); scene.add(pl2)
    const pl3 = new THREE.PointLight(0x10b981, 0.8, 30); pl3.position.set(0, -2, 4); scene.add(pl3)
    const pl4 = new THREE.PointLight(0x3b82f6, 0.6, 20); pl4.position.set(3, -1, -3); scene.add(pl4)

    const car = new THREE.Group()
    car.scale.setScalar(1.3)
    car.position.y = -0.2
    const mat1 = new THREE.MeshStandardMaterial({ color: 0x00d4ff, wireframe: true, transparent: true, opacity: 0.55 })
    const mat2 = new THREE.MeshStandardMaterial({ color: 0x00d4ff, wireframe: true, transparent: true, opacity: 0.4 })
    const body = new THREE.Mesh(new THREE.BoxGeometry(3, 0.5, 1.4), mat1); body.position.y = 0.35; car.add(body)
    const cabin = new THREE.Mesh(new THREE.BoxGeometry(1.5, 0.55, 1.25), mat2); cabin.position.set(0.15, 0.8, 0); car.add(cabin)
    const wMat = new THREE.MeshStandardMaterial({ color: 0x10b981, wireframe: true, transparent: true, opacity: 0.65 })
    for (const p of [[-1, 0, 0.7], [-1, 0, -0.7], [1, 0, 0.7], [1, 0, -0.7]]) {
      const w = new THREE.Mesh(new THREE.TorusGeometry(0.24, 0.09, 10, 20), wMat)
      w.position.set(p[0], p[1], p[2]); w.rotation.x = Math.PI / 2; car.add(w)
    }
    const hlMat = new THREE.MeshStandardMaterial({ color: 0xfbbf24, emissive: 0xfbbf24, emissiveIntensity: 3, wireframe: true })
    for (const p of [[1.5, 0.35, 0.48], [1.5, 0.35, -0.48]]) {
      const h = new THREE.Mesh(new THREE.SphereGeometry(0.1, 10, 10), hlMat); h.position.set(p[0], p[1], p[2]); car.add(h)
    }
    const tlMat = new THREE.MeshStandardMaterial({ color: 0xef4444, emissive: 0xef4444, emissiveIntensity: 2, wireframe: true })
    for (const p of [[-1.5, 0.35, 0.48], [-1.5, 0.35, -0.48]]) {
      const t = new THREE.Mesh(new THREE.SphereGeometry(0.08, 8, 8), tlMat); t.position.set(p[0], p[1], p[2]); car.add(t)
    }
    const chassis = new THREE.Mesh(new THREE.BoxGeometry(3.2, 0.04, 1.5), new THREE.MeshStandardMaterial({ color: 0x3b82f6, wireframe: true, transparent: true, opacity: 0.2 }))
    chassis.position.y = 0.1; car.add(chassis)
    const eng = new THREE.Mesh(new THREE.BoxGeometry(0.7, 0.35, 0.7), new THREE.MeshStandardMaterial({ color: 0xa855f7, wireframe: true, transparent: true, opacity: 0.35 }))
    eng.position.set(1.1, 0.45, 0); car.add(eng)
    scene.add(car)

    const grid = new THREE.Mesh(new THREE.PlaneGeometry(40, 40, 40, 40), new THREE.MeshStandardMaterial({ color: 0x0a1628, wireframe: true, transparent: true, opacity: 0.1 }))
    grid.rotation.x = -Math.PI / 2; grid.position.y = -0.6; scene.add(grid)

    const pGeo = new THREE.BufferGeometry()
    const pPos = new Float32Array(500 * 3)
    const pCol = new Float32Array(500 * 3)
    for (let i = 0; i < 500; i++) {
      pPos[i*3] = (Math.random()-0.5)*25; pPos[i*3+1] = (Math.random()-0.5)*12; pPos[i*3+2] = (Math.random()-0.5)*25
      const c = new THREE.Color().setHSL(0.5 + Math.random() * 0.2, 0.8, 0.6)
      pCol[i*3] = c.r; pCol[i*3+1] = c.g; pCol[i*3+2] = c.b
    }
    pGeo.setAttribute('position', new THREE.BufferAttribute(pPos, 3))
    pGeo.setAttribute('color', new THREE.BufferAttribute(pCol, 3))
    const particles = new THREE.Points(pGeo, new THREE.PointsMaterial({ size: 0.03, vertexColors: true, transparent: true, opacity: 0.5, sizeAttenuation: true }))
    scene.add(particles)

    for (let i = 0; i < 3; i++) {
      const ring = new THREE.Mesh(new THREE.TorusGeometry(2.5 + i * 0.8, 0.005, 16, 100), new THREE.MeshStandardMaterial({ color: 0x00d4ff, transparent: true, opacity: 0.08 + i * 0.02 }))
      ring.rotation.x = Math.PI / 2.5 + i * 0.15; ring.rotation.z = i * 0.3; scene.add(ring)
    }

    let angle = 0, animId = 0
    const animate = () => {
      animId = requestAnimationFrame(animate)
      const t = Date.now() * 0.001
      angle += 0.003
      car.rotation.y += 0.002
      car.position.y = -0.2 + Math.sin(t) * 0.08
      particles.rotation.y += 0.0002
      particles.rotation.x = Math.sin(t * 0.2) * 0.02
      pl1.position.x = Math.sin(t * 0.5) * 6
      pl2.position.z = Math.cos(t * 0.3) * 6
      camera.position.x = 6 * Math.cos(angle)
      camera.position.z = 6 * Math.sin(angle)
      camera.position.y = 2.5 + Math.sin(t * 0.3) * 0.3
      camera.lookAt(0, 0, 0)
      renderer.render(scene, camera)
    }
    animate()

    const onResize = () => { camera.aspect = el.clientWidth / el.clientHeight; camera.updateProjectionMatrix(); renderer.setSize(el.clientWidth, el.clientHeight) }
    window.addEventListener('resize', onResize)
    return () => { cancelAnimationFrame(animId); window.removeEventListener('resize', onResize); if (el.contains(renderer.domElement)) el.removeChild(renderer.domElement); renderer.dispose() }
  }, [])
  return <div ref={mountRef} className="absolute inset-0" />
}
