(* Types *)

type var = string
type kind = int
type sort = LetS | VarS | FuncS | ClassS | ProhibitedS

type typ =
  | Var of var * typ list
  | Bot
  | Null
  | Bool
  | Byte
  | Int
  | Float
  | Text
  | Obj
  | Tup of typ list
  | Array of typ
  | Func of var list * typ list * typ
  | Inst of cls * typ list
  | Class of cls

and cls =
  { name : var;
    id : int;
    tparams : var list;
    mutable vparams : typ list;
    mutable sup : typ;
    mutable def : (sort * typ) Env.Map.t;
  }


(* Constructors *)

val var : var -> typ


(* Operations *)

val eq : typ -> typ -> bool
val sub : typ -> typ -> bool
val lub : typ -> typ -> typ (* raises Failure *)

val free : typ -> Env.Set.t

val to_string : typ -> string


(* Classes *)

val gen_class : 'id -> var -> var list -> cls
val eq_class : cls -> cls -> bool


(* Substitutions *)

module Subst = Env.Map

type con = typ list -> typ
type subst = con Subst.t

val subst : subst -> typ -> typ

val empty_subst : subst
val adjoin_subst : subst -> subst -> subst

val lookup_subst : subst -> var -> con option
val extend_subst : subst -> var -> con -> subst
val extend_subst_typ : subst -> var -> typ -> subst
val extend_subst_abs : subst -> var -> subst

val typ_subst : var list -> typ list -> subst
