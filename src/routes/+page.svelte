<script>
	let isSale = $state(false);
	let monthlyRentalAboveTenThousand = $state(false);
</script>

<main class="p-8">
  <h1 class="text-4xl mb-4">Risk Assessment</h1>

  <h2 class="text-2xl">Client</h2>

  <form>
    <div>
      <div class="py-4">
        <div>
          <input type="radio" id="physical" name="client_type" value="Physical Person">
          <label for="physical">Physical Person</label>
        </div>
  
        <div>
          <input type="radio" id="company" name="client_type" value="Company">
          <label for="company">Company</label>
        </div>
  
        <div>
          <input type="radio" id="trust_foundation" name="client_type" value="Trust/Foundation">
          <label for="trust_foundation">Trust/Foundation</label>
        </div>
      </div>

      <div>
        <input type="checkbox" name="pep">
        <label for="pep">Politically Exposed Person (PEP)</label>
      </div>

      <div>
        <input type="checkbox" name="industry" id="industry">
        <label for="industry">Works in industry with high ML/FT risk, e.g. Casino owner</label>
      </div>
      
      <div>
        <input type="checkbox" id="non_identified_third_party" name="non_identified_third_party">
        <label for="non_identified_third_party">Non-identified person not directly involved in final transaction is present</label>
      </div>
    
      <div>
        <input type="checkbox" name="sanction" id="sanction">
        <label for="sanction">Client is subject to sanctions</label>
      </div>

      <div>
        <input type="checkbox" name="odd_behaviour" id="odd_behaviour">
        <label for="odd_behaviour">Client has odd behaviour</label>
      </div>
      
      <div>
        <input type="checkbox" name="hurried" id="hurried">
        <label for="hurried">Client in a hurry for no apparent reason</label>
      </div>
    </div>

    <h2 class="text-2xl mt-8">Service</h2>

    <div class="py-4">
      <div>
        <input type="radio" id="sale" checked={isSale} value="sale" onclick={() => { isSale = true}} >
        <label for="sale">Sale</label>
      </div>

      <div>
        <input type="radio" id="rental" checked={!isSale} value="rental" onclick={() => { isSale = false}} >
        <label for="rental">Rental</label>
      </div>
    
      <div class="py-4">
        {#if isSale}
          <input type="radio" id="new" name="build" value="new">
          <label for="new">New Build</label>
          
          <input type="radio" id="old" name="build" value="old">
          <label for="old">Old Build</label>
        {:else}
          <input type="checkbox" id="new" name="build" value="new" bind:checked={monthlyRentalAboveTenThousand}>
          <label for="new">Monthly Rent > 10 000 euros</label>
          
          {#if monthlyRentalAboveTenThousand}
            <input type="radio" id="primary" name="monthly_rental" value="above_10_000_primary">
            <label for="primary">Main Residence</label>
            
            <input type="radio" id="secondary" name="monthly_rental" value="above_10_000_secondary">
            <label for="secondary">Secondary Residence</label>
          {/if}
        {/if}
      </div>
    </div>

    <h2 class="text-2xl">Transaction</h2>

    <fieldset class="py-4">
      <label for="cash">Amount</label>
      <input type="text" id="transaction_amount" name="transaction_amount" min="0">
    
      <h3 class="text-large font-bold">Means of Payment</h3>

      <fieldset class="py-4">
        <input type="radio" id="cash" name="means_of_payment" value="cash">
        <label for="cash">Cash</label>
        
        <input type="radio" id="bank_transfer" name="means_of_payment" value="bank_transfer">
        <label for="bank_transfer">Bank transfer</label>
        
        <input type="radio" id="cheque" name="means_of_payment" value="cheque">
        <label for="cheque">Cheque</label>
      </fieldset>
      
      <input type="checkbox" id="fractional_payments" name="fractional_payments" value="new">
      <label for="fractional_payments">Fractional payments</label>
    
      <input type="checkbox" id="complex_transactions" name="complex_transactions" value="new">
      <label for="complex_transactions">Complex transactions</label>
    
      <input type="checkbox" id="complex_transactions" name="complex_transactions" value="new">
      <label for="complex_transactions">Property undervalued or overvalued</label>
    </fieldset>

    <h2 class="text-2xl mb-2">Distribution</h2>

    <fieldset class="py-4">
      <input type="checkbox" id="client_remote" name="client_remote" value="client_remote">
      <label for="client_remote">Client is remote</label>

      <br />
      <input type="checkbox" id="through_intermediary" name="through_intermediary" value="go_between_present">
      <label for="through_intermediary">Through Intermediary</label>
    </fieldset>

    <h2 class="text-2xl mb-2">Country</h2>

    <fieldset class="py-4">
      <div>
        <label for="country_residence" class="block text-sm font-medium leading-6 text-gray-900">Country of Residence</label>
        <select name="country_residence" class="mt-2 block w-full rounded-md border-0 py-1.5 pl-3 pr-10 text-gray-900 ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-indigo-600 sm:text-sm sm:leading-6">
          <option value="">-- Select Country --</option>
          <option value="monaco">Monaco</option>
          <option value="eu">EU</option>
          <option value="non_eu">non-EU</option>
        </select>
      </div>

      <div>
        <label for="country_profession" class="block text-sm font-medium leading-6 text-gray-900">Country of Profession</label>
        <select name="country_profession" class="mt-2 block w-full rounded-md border-0 py-1.5 pl-3 pr-10 text-gray-900 ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-indigo-600 sm:text-sm sm:leading-6">
          <option value="">-- Select Country --</option>
          <option value="monaco">Monaco</option>
          <option value="eu">EU</option>
          <option value="non_eu">non-EU</option>
        </select>
      </div>

      <div>
        <label for="country_funds" class="block text-sm font-medium leading-6 text-gray-900">Country of Origin of Funds</label>
        <select name="country_funds" class="mt-2 block w-full rounded-md border-0 py-1.5 pl-3 pr-10 text-gray-900 ring-1 ring-inset ring-gray-300 focus:ring-2 focus:ring-indigo-600 sm:text-sm sm:leading-6">
          <option value="">-- Select Country --</option>
          <option value="monaco">Monaco</option>
          <option value="eu">EU</option>
          <option value="non_eu">non-EU</option>
        </select>
      </div>
    </fieldset>
    
    <button type="button" class="rounded-md bg-indigo-600 px-3.5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-500 focus-visible:outline focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-indigo-600">Submit</button>
  </form>
</main>
