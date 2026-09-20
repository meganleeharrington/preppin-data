select transaction_id
    ,concat('GB',check_digits, swift_code, replace(sort_code, '-', ''), account_number) as IBAN
from pd2023_wk02_transactions tr
left join pd2023_wk02_swift_codes sc
on tr.bank = sc.bank;
