--Goddess Bow
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcCodeFun(c,25652259,282,1,true,true)

	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(876330,0))
	e0:SetCategory(CATEGORY_EQUIP)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e0:SetTarget(s.target)
	e0:SetOperation(s.operation)
	c:RegisterEffect(e0)

	--Double ATK
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_EQUIP)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)

	--Equip Limit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetValue(s.eqlimit)
	c:RegisterEffect(e3)
	
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)	

	--Activates a monster effect they control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11881272,0))
	e2:SetType(EFFECT_TYPE_QUICK_O) 
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCode(EVENT_CHAINING)
	e2:SetCondition(s.con)
	e2:SetOperation(s.op)
	c:RegisterEffect(e2)
end
s.listed_names={25652259,282}

function s.filter(c)
	return c:IsFaceup() 
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and s.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,e:GetHandler(),tc)
	end
end

function s.eqlimit(e,c)
return c:IsFaceup()
end
function s.ffilter(c)
return c:IsCode(170000153) and c:IsType(TYPE_SPELL)
end
function s.atkval(e,c)
return c:GetBaseAttack()
end
function s.con(e,tp,eg,ep,ev,re,r,rp,chk)
	local ph=Duel.GetCurrentPhase()
	return not e:GetHandler():GetEquipTarget():IsStatus(STATUS_BATTLE_DESTROYED) and ep~=tp 
		and (ph>PHASE_MAIN1 and ph<PHASE_MAIN2) and re:IsActiveType(TYPE_MONSTER)
		and (Duel.GetAttacker()==e:GetHandler():GetEquipTarget() or Duel.GetAttackTarget()==e:GetHandler():GetEquipTarget())
			and e:GetHandler():GetEquipTarget():CanChainAttack(100,false) 
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local et=e:GetHandler():GetEquipTarget()
	Duel.ChainAttack()
	--local e2=Effect.CreateEffect(e:GetHandler()) 
	--e2:SetType(EFFECT_TYPE_SINGLE) 
	--e2:SetCode(EFFECT_EXTRA_ATTACK) 
	--e2:SetReset(RESET_EVENT+0x1fe0000)   
	--e2:SetValue(1) 
	  --et:RegisterEffect(e2) 

	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
	e3:SetValue(1)
	et:RegisterEffect(e3)
end
