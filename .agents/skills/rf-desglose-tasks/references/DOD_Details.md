# Definition of Done (DOD)

Un PBI se considera **Done** cuando cumple **todos** los criterios aplicables:

---

## 1. Desarrollo Completado

- [ ] **1.1** Se respetan las convenciones de nombres de la suite Axxon 365 (prefijo `Axn` + código de módulo). 🔴
- [ ] **1.2** El código sigue las best practices de X++ y D365 F&O (extensibilidad, no overlayering, uso de CoC). 🔴
- [ ] **1.3** Los artefactos de Electronic Reporting y Templates de configuración están versionados y exportados correctamente. 🟡

## 2. Calidad del Código (Code Review)

- [ ] **2.1** Se realizó Code Review por un par distinto al desarrollador siguiendo el Checklist Dinámico. 🔴

## 3. Testing

- [ ] **3.1** Se ejecutaron pruebas unitarias que cubren los escenarios de los criterios de aceptación. 🔴
- [ ] **3.2** Se ejecutaron pruebas de integración entre módulos cuando la funcionalidad depende de otros componentes. 🟡
- [ ] **3.3** Si la funcionalidad es de país específico, se validó con datos fiscales representativos del país. 🟡
- [ ] **3.4** Todos los defectos encontrados en testing están resueltos o documentados como items separados con prioridad asignada. 🔴

## 4. Licenciamiento y Feature Management

- [ ] **4.1** La funcionalidad está correctamente registrada en el módulo de License Management. 🔴
- [ ] **4.2** La funcionalidad se puede activar/desactivar por Legal Entity sin afectar otros módulos ni el estándar de D365. 🔴
- [ ] **4.3** Con la licencia desactivada, no genera errores ni interfiere con el comportamiento estándar de D365 F&O. 🔴

## 5. Documentación

- [ ] **5.1** La documentación técnica mínima está actualizada (qué hace y qué objetos interviene). 🔴
- [ ] **5.2** Se generó el Manual de Configuración (parámetros/diccionario). 🔴
- [ ] **5.3** Se generó el Manual de Usuario por separado. 🔴
- [ ] **5.4** El archivo de alcance fue actualizado con el Estado correcto. 🔴

## 6. Despliegue y Cierre

- [ ] **6.1** El paquete NuGet del módulo se genera correctamente y es desplegable. 🔴
- [ ] **6.2** Las configuraciones de Electronic Reporting y Entidades de Datos fueron empaquetadas e importables. 🟡
- [ ] **6.3** El WIT en Azure DevOps fue actualizado al estado Closed. 🔴
- [ ] **6.4** El código fue integrado y el pipeline de build pasa exitosamente. 🔴

---

🔴 Obligatorio    🟡 Condicional
