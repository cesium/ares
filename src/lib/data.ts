import { supabase } from "./supabase.ts";

export async function register(name: any, email: any): Promise<boolean> {
  try {
    // Insert the data into the 'forms' table
    const { data, error } = await supabase
      .from("forms")
      .insert([{ name: name.value, email: email.value }]);
    if (error) {
      return false;
    }
    return true;
  } catch (error) {
    return false; // Indicate failure
  }
}
