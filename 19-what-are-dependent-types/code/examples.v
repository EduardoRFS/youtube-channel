Definition not (b : bool) :=
  match b with
  | true => false
  | false => true
  end.

Definition not_true_eq_false : (not true) = false := eq_refl.
Definition not_false_eq_true : (not false) = true := eq_refl.

Definition zero_add_zero_eq_zero : 0 + 0 = 0 := eq_refl.
Definition zero_add_one_eq_one : 0 + 1 = 1 := eq_refl.
Definition zero_add_two_eq_two : 0 + 2 = 2 := eq_refl.

Definition zero_add_n_eq_n : forall (n : nat), 0 + n = n :=
  fun n => eq_refl.
Lemma n_add_zero_eq_n : forall (n : nat), n + 0 = n.
  intros n.
  induction n.
  - simpl. reflexivity.
  - simpl. rewrite IHn. reflexivity.
Qed.

Lemma true_neq_false : true <> false.
  unfold "<>".
  intros eq.
  discriminate.
Qed.
