--拓扑战士(neet)
local s,id=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--Synchro Summon procedure
	Synchro.AddProcedure(c,nil,1,1,Synchro.NonTuner(nil),1,99)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(s.condition)
	e1:SetValue(s.efilter)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e3:SetCountLimit(1)
	e3:SetCost(s.cost)
	e3:SetTarget(s.seqtg)
	e3:SetOperation(s.seqop)
	c:RegisterEffect(e3)
	--atk
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_ATKCHANGE)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(s.atkcon)
	e4:SetTarget(s.atktg)
	e4:SetOperation(s.atkop)
	c:RegisterEffect(e4)
end
function s.efilter(e,re)
	return e:GetOwnerPlayer()==1-re:GetOwnerPlayer()
end
function s.filter(c,tc)
	return c:IsLinkAbove(3) and c:IsType(TYPE_LINK) and c:IsRace(RACE_CYBERSE) and c:GetLinkedGroup():IsContains(tc)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=e:GetHandlerPlayer()
	return c:IsFaceup() and Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,c)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ttp=e:GetHandlerPlayer()
	if chk==0 then return tp==ttp or (tp==1-ttp and Duel.CheckLPCost(1-ttp,500)) end
	if tp==1-ttp then Duel.PayLPCost(1-ttp,500) end
end
function s.seqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 end
end
function s.seqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ttp=e:GetHandlerPlayer()
	if not c:IsRelateToEffect(e) or c:IsControler(1-ttp) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	local seq=Duel.SelectDisableField(ttp,1,LOCATION_MZONE,0,0)
	Duel.Hint(HINT_ZONE,ttp,seq)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
	Duel.MoveSequence(c,math.log(seq,2))
end
function s.cfilter(c,tc)
	return c:IsType(TYPE_LINK) and c:GetLinkedGroup():IsContains(tc)
end
function s.atkcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	local tc=c:GetBattleTarget()
	e:SetLabelObject(tc)
	return tc and tc:IsFaceup() and #g>0
end
function s.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetLabelObject():CreateEffectRelation(e)
end
function s.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=e:GetLabelObject()
	local g=Duel.GetMatchingGroup(s.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsControler(1-tp) and not tc:IsImmuneToEffect(e) and #g>0 then
		local ct=0
		for lc in aux.Next(g) do
			ct=ct+lc:GetLink()
		end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(ct*-300)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end