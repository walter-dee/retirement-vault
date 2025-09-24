;; Retirement Vault Smart Contract
;; Time-locked pension savings on Stacks blockchain

;; Error codes
(define-constant ERR-FUTURE-DATE (err u100))
(define-constant ERR-ZERO-AMOUNT (err u101))
(define-constant ERR-NO-VAULT (err u102))
(define-constant ERR-LOCKED (err u103))
(define-constant ERR-NO-BENEFICIARY (err u104))
(define-constant ERR-NOT-AUTHORIZED (err u105))

;; Storage
(define-map vaults 
  principal 
  {
    amount: uint,
    unlock-date: uint,
    beneficiary: (optional principal)
  }
)


(define-read-only (get-vault (owner principal))
  (map-get? vaults owner))

;; Public functions
(define-public (deposit (unlock-date uint) (beneficiary (optional principal)) (amount uint))
  (let ((sender tx-sender))
    (begin
      (asserts! (> unlock-date burn-block-height) ERR-FUTURE-DATE)
      (asserts! (> amount u0) ERR-ZERO-AMOUNT)
      (asserts! (or (is-none beneficiary) 
                   (not (is-eq sender (unwrap! beneficiary ERR-NO-BENEFICIARY))))
               ERR-NOT-AUTHORIZED)
      (try! (stx-transfer? amount sender (as-contract sender)))
      (ok (map-set vaults sender {
        amount: amount,
        unlock-date: unlock-date,
        beneficiary: beneficiary
      }))
    )
  )
)

(define-public (withdraw)
  (let ((sender tx-sender)
        (vault (unwrap! (map-get? vaults sender) ERR-NO-VAULT)))
    (let ((amount (get amount vault))
          (unlock (get unlock-date vault)))
      (asserts! (>= burn-block-height unlock) ERR-LOCKED)
      (try! (stx-transfer? amount (as-contract sender) sender))
      (map-delete vaults sender)
      (ok amount)
    )
  )
)

(define-public (claim-inheritance (owner principal))
  (let ((vault (unwrap! (map-get? vaults owner) ERR-NO-VAULT)))
    (let ((amount (get amount vault))
          (unlock (get unlock-date vault))
          (beneficiary (get beneficiary vault))
          (sender tx-sender))
      (asserts! (is-some beneficiary) ERR-NO-BENEFICIARY)
      (asserts! (is-eq (unwrap! beneficiary ERR-NO-BENEFICIARY) sender) ERR-NOT-AUTHORIZED)
      (asserts! (>= burn-block-height unlock) ERR-LOCKED)
      (try! (stx-transfer? amount (as-contract sender) sender))
      (map-delete vaults owner)
      (ok amount)
    )
  )
)