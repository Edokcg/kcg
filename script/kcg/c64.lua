--No.39 希望皇ホープ・ルーツ
local s, id = GetID()
function s.initial_effect(c)
		--xyz summon
	  Xyz.AddProcedure(c,nil,1,2)
		c:EnableReviveLimit()
	  --cannot destroyed
		local e0=Effect.CreateEffect(c)
	  e0:SetType(EFFECT_TYPE_SINGLE)
	  e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	  e0:SetValue(s.indes)
	  c:RegisterEffect(e0)
		--disable attack
		local e1=Effect.CreateEffect(c)  
		e1:SetDescription(aux.Stringid(7845138,0))  
		e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	  e1:SetCode(EVENT_FREE_CHAIN)
	  e1:SetHintTiming(TIMING_BATTLE_PHASE)
	  e1:SetRange(LOCATION_MZONE)
		e1:SetCondition(s.atkcon)
		e1:SetCost(Cost.DetachFromSelf(1,1,function(e,og) Duel.Overlay(e:GetHandler():GetBattleTarget(),og) end))
		e1:SetTarget(s.atktg)
		e1:SetOperation(s.atkop)
		c:RegisterEffect(e1)
end
s.xyz_number=39
s.listed_series = {0x48}

 function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end
function s.desfilter2(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) and (not c:IsSetCard(0x48) or c:IsSetCard(0x1048))
end
function s.descon2(e)
	local c=e:GetHandler()
	return Duel.IsExistingMatchingCard(s.desfilter2,c:GetControler(),0,LOCATION_MZONE,1,c)
end
 function s.atkfilter(c)
		return e:GetHandler():GetOverlayGroup()
end
function s.atkcon(e)
	local c=e:GetHandler()
	local bt=c:GetBattleTarget()
	return bt~=nil and bt:IsType(TYPE_XYZ) and bt:IsFaceup() and not e:GetHandler():IsStatus(STATUS_CHAINING)
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp)
	local o=e:GetHandler():GetOverlayGroup() 
	local c=e:GetHandler()
	local bt=c:GetBattleTarget()
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(47660516,0))
	local g=o:Select(tp,1,1,nil)
	Duel.Overlay(bt,g)
	--Duel.RaiseSingleEvent(e:GetHandler(),EVENT_DETACH_MATERIAL,e,0,0,0,0)
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) end
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_EFFECT) then return end
	local c=e:GetHandler()
	local o=c:GetOverlayGroup() 
	local bt=c:GetBattleTarget()
	local tc=Duel.GetAttacker()
	if tc==c then tc=Duel.GetAttackTarget() end
	if Duel.GetAttacker()==e:GetHandler() then
		Duel.NegateAttack() end
		if tc:IsType(TYPE_XYZ) and tc:IsFaceup()
				and c:IsRelateToEffect(e) and c:IsFaceup() then
		local diff=(tc:GetRank()-c:GetRank())*100
		if diff==0 then diff=1 end
		if diff<0 then diff=diff*(-1) end
		local val=diff*tc:GetOverlayCount() 
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(val)
		c:RegisterEffect(e1)
		end
end