# Retirement Vault Smart Contract

A secure, time-locked STX vault system implemented on the Stacks blockchain for retirement savings and inheritance planning.

## Features

- 🔒 **Secure Time-Locked Deposits**: Lock your STX tokens until a specified future date
- 👥 **Beneficiary System**: Designate beneficiaries for inheritance planning
- ⚡ **Efficient Storage**: Optimized data structure using Clarity maps
- 🛡️ **Built-in Security**: Comprehensive error handling and input validation
- 📊 **Transparency**: Read-only functions to query vault details

## Functions

### Public Functions

- `deposit`: Create a new vault with time-locked STX
- `withdraw`: Withdraw STX after the unlock date
- `claim-inheritance`: Allow beneficiaries to claim funds after unlock date

### Read-Only Functions

- `get-vault`: Query vault details for any principal

## Error Codes

| Code | Description |
|------|-------------|
| u100 | Unlock date must be in the future |
| u101 | Deposit amount must be greater than zero |
| u102 | No vault found for the specified owner |
| u103 | Vault is still locked |
| u104 | No beneficiary set for inheritance claim |
| u105 | Not authorized to perform this action |

## Usage

### Creating a Vault
```clarity
(contract-call? .retirement-vault deposit u144000 none u1000000)
```

### Withdrawing Funds
```clarity
(contract-call? .retirement-vault withdraw)
```

### Setting Up Inheritance
```clarity
(contract-call? .retirement-vault deposit u144000 (some ST1HTBVD3JG9C05J7HBJTHGR0GGW7KXW28M5JS8QE) u1000000)
```

## Development

### Prerequisites
- [Clarinet](https://github.com/hirosystems/clarinet)
- [Stacks Blockchain](https://www.stacks.co/developers)

### Testing
```bash
clarinet test
```

### Deployment
```bash
clarinet deploy
```

## Security Considerations

- All deposits are time-locked until the specified unlock date
- Only vault owners can withdraw funds
- Beneficiaries can only claim after the unlock date
- Contract uses safe STX transfer patterns
- Built-in protection against common vulnerabilities

---
Built with ❤️ for the Stacks ecosystem
