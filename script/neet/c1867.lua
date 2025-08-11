--银河眼扩散光波龙(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Xyz Summon procedure
	Xyz.AddProcedure(c,nil,10,3,s.ovfilter,aux.Stringid(id,1),2,s.xyzop)
	--Cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(function(e) return e:GetHandler():GetOverlayCount()>0 end)
	e1:SetValue(aux.tgoval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_CONTROL+CATEGORY_NEGATE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCost(Cost.DetachFromSelf(1,1,nil))
	e3:SetCountLimit(1)
	e3:SetCondition(s.discon)
	e3:SetTarget(s.distg)
	e3:SetOperation(s.disop)
	c:RegisterEffect(e3,false,EFFECT_MARKER_DETACH_XMAT)
end
s.listed_names={id}
s.listed_series={SET_CIPHER_DRAGON}
function s.ovfilter(c,tp,lc)
	return c:IsSetCard(SET_CIPHER_DRAGON,lc,SUMMON_TYPE_XYZ,tp) and c:IsFaceup()
end
function s.xyzop(e,tp,chk)
	if chk==0 then return not Duel.HasFlagEffect(tp,id) end
	Duel.RegisterFlagEffect(tp,id,RESET_PHASE|PHASE_END,EFFECT_FLAG_OATH,1)
	return true
end
function s.discon(e,tp,eg,ep,ev,re,r,rp)
	local tgp,loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CONTROLER,CHAININFO_TRIGGERING_LOCATION)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainDisablable(ev)
		and tgp~=tp and re:IsActiveType(TYPE_MONSTER) and loc==LOCATION_MZONE and re:GetHandler():IsControlerCanBeChanged()
end
function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,eg,1,0,0)
end
function s.disop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.NegateActivation(ev) then return end
	local tc=re:GetHandler()
	local c=e:GetHandler()
	if tc:IsRelateToEffect(re) and Duel.GetControl(tc,tp) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE)
		e2:SetCondition(s.concon)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_DISABLE_EFFECT)
		e3:SetCondition(s.concon)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_SET_ATTACK_FINAL)
		e4:SetCondition(s.concon)
		e4:SetValue(4200)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e4)
		local e5=Effect.CreateEffect(c)
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CHANGE_CODE)
		e5:SetCondition(s.concon)
		e5:SetValue(id)
		e5:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e5)
	end
end
function s.concon(e)
	for _,eff in ipairs({e:GetHandler():GetCardEffect(EFFECT_SET_CONTROL)}) do
		if eff:GetOwner()==e:GetOwner() then return true end
	end
	return false
end