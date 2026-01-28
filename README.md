# DR Soluções - PDV & Gestão Offline (Modo 1 arquivo)

WebApp offline-first para loja de roupas, rodando apenas com `index.html` (sem backend). Dados ficam no **IndexedDB** e preferências no **LocalStorage**.

## Como usar

1. Abra `index.html` em um navegador moderno (Chrome/Edge/Firefox).
2. Primeiro acesso: usuário `admin` senha `1234`.
3. Use o menu lateral para navegar entre PDV, Produtos, Clientes, Estoque, Caixa, Relatórios e Configurações.

## Impressão 80mm

* O cupom é impresso via `window.print()`.
* Clique em **Imprimir cupom** após finalizar a venda.
* Garanta que a impressora térmica esteja configurada para **80mm** no sistema.

## Leitor de código de barras

* **USB**: o leitor atua como teclado. Basta focar o campo de busca no PDV.
* **Câmera**: clique em **Ler câmera** (usa BarcodeDetector API, se suportada pelo navegador).

## Backup e restauração

* Vá em **Configurações > Backup**.
* **Exportar JSON completo** cria um backup total do banco.
* **Importar JSON** permite mesclar ou substituir dados.

## Importação de produtos (CSV)

Na tela de Produtos, baixe o template CSV e preencha:

```
name,sku,barcode,category,brand,price,cost,variants_json,unit,supplier,status
```

`variants_json` deve estar no formato JSON, exemplo:

```
[{"size":"P","color":"Preto","stock":10}]
```

## Dados seed

Ao iniciar pela primeira vez são criados automaticamente:

* 10 produtos de exemplo
* 5 clientes de exemplo
* Usuários: admin, gerente, operador (senha padrão: 1234)

## Checklist manual de testes (PDV)

- [ ] Buscar produto por nome ou código de barras
- [ ] Adicionar item ao carrinho
- [ ] Testar desconto por item
- [ ] Aplicar desconto geral e taxa
- [ ] Finalizar venda em dinheiro e conferir troco
- [ ] Imprimir cupom 80mm
- [ ] Confirmar baixa de estoque
- [ ] Verificar lançamento no Caixa

## Observações

* Sistema funciona offline-first.
* Preparado para exportação/importação e futura integração com APIs.

---

WhatsApp DR Soluções: **35991617669**
