--No.62 銀河眼の光子竜皇
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	Xyz.AddProcedure(c,nil,8,2)
	c:EnableReviveLimit()

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)
	  
	-- Level/Rank
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetCode(EFFECT_LEVEL_RANK)
	e3:SetTarget(function (e,c) return not c:IsType(TYPE_XYZ) end)
	c:RegisterEffect(e3)
	
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(16719802,0))
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1)
	e5:SetTarget(s.ranktg)
	e5:SetOperation(s.rankop)
	c:RegisterEffect(e5)

	--atk
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(31801517,0))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_PRE_DAMAGE_CALCULATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.atkcon)
	e1:SetCost(s.atkcost)
	e1:SetOperation(s.atkop)
	c:RegisterEffect(e1)

	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetCondition(s.spcon)
	e2:SetOperation(s.spop0)
	c:RegisterEffect(e2)
end
s.xyz_number=62
s.listed_names={CARD_GALAXYEYES_P_DRAGON}
s.listed_series = {0x48}

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.rankfilter(c)
	  return c:IsFaceup() and c:GetRank()<13
end
function s.ranktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMatchingGroupCount(s.rankfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)>0 end
end
function s.rankop(e,tp,eg,ep,ev,re,r,rp)
	   local c=e:GetHandler()
	   local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	   local tc=g:GetFirst()
	   while tc do
	   if tc:GetRank()<13 then
	   local e4=Effect.CreateEffect(c)
	   e4:SetType(EFFECT_TYPE_SINGLE)
	   e4:SetCode(EFFECT_UPDATE_RANK)
	   e4:SetReset(RESET_EVENT+0x1fe0000)
	   e4:SetValue(1)
	   tc:RegisterEffect(e4) end
	   tc=g:GetNext() end
end
 function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c==Duel.GetAttacker() or c==Duel.GetAttackTarget()
	and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,CARD_GALAXYEYES_P_DRAGON)
end
function s.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:GetFlagEffect(id)==0 end
	c:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL,0,1)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local val=g:GetSum(Card.GetRank)*200
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_DAMAGE_CAL)
		c:RegisterEffect(e1)
	end
end

 function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetOverlayCount()
	e:SetLabel(ct)
	return c:IsLocation(LOCATION_MZONE) and c:IsControler(tp) and ct>0
	and c:GetOverlayGroup():IsExists(Card.IsCode,1,nil,CARD_GALAXYEYES_P_DRAGON)
end
function s.spop0(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=e:GetLabel()
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetOperation(s.spop)
	e2:SetLabel(count)
	c:RegisterEffect(e2)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local count=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_REMOVED+LOCATION_GRAVE)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	if Duel.GetCurrentPhase()==PHASE_STANDBY and Duel.GetTurnPlayer()==tp then
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,count+1)
	else
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_STANDBY+RESET_SELF_TURN,count)
	end
	e1:SetLabel(count)
	e1:SetCountLimit(1)
	e1:SetOperation(s.spop2)
	c:RegisterEffect(e1)
	c:SetTurnCounter(0)
	e:Reset()
end
function s.spop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetTurnPlayer()~=tp then return end
	local c=e:GetHandler() 
	local count=e:GetLabel()
	local ct=c:GetTurnCounter()
	ct=ct+1
	c:SetTurnCounter(ct)
	if ct==count then
		Duel.SpecialSummonStep(c,0,tp,tp,false,false,POS_FACEUP)
			local e11=Effect.CreateEffect(c)
			e11:SetType(EFFECT_TYPE_SINGLE)
			e11:SetRange(LOCATION_MZONE)
			e11:SetValue(1)
			e11:SetCode(EFFECT_CANNOT_DISABLE)
			e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
			e11:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e11)
		  --atk
		  local e0=Effect.CreateEffect(c)
		  e0:SetDescription(aux.Stringid(31801517,0))
		  e0:SetCategory(CATEGORY_ATKCHANGE)
		  e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		  e0:SetCode(EVENT_ATTACK_ANNOUNCE)
		  e0:SetLabel(count)
		  e0:SetOperation(s.atkop2)
		  e0:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		  c:RegisterEffect(e0)
		Duel.SpecialSummonComplete()
	end
end
function s.atkop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	  local count=e:GetLabel()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK_FINAL)
	e1:SetValue(c:GetAttack()*count)
	e1:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end