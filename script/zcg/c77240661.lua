--BT黑羽 雷神鸟(ZCG)
local s,id=GetID()
function s.initial_effect(c)
	if aux.IsKCGScript then
		Synchro.AddProcedure(c,s.tfilter2,1,1,Synchro.NonTuner(nil),2,99)
	else
		aux.AddSynchroProcedure(c,s.tfilter,aux.NonTuner(nil),2)
	end
	c:EnableReviveLimit()
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.destg)
	e3:SetOperation(s.desop)
	c:RegisterEffect(e3)
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function s.tfilter(c)
	return c:IsSetCard(0x33) 
end
function s.tfilter2(c,scard,sumtype,tp)
	return c:IsSetCard(0x33,scard,sumtype,tp) or c:IsHasEffect(EFFECT_SYNSUB_NORDIC)
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,1,2,nil)
	if g:GetCount()>0 then
		Duel.Destroy(g,REASON_EFFECT)
		 local e1=Effect.CreateEffect(e:GetHandler())
		 e1:SetType(EFFECT_TYPE_SINGLE)
		 e1:SetCode(EFFECT_CANNOT_ATTACK)
		 e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		 e:GetHandler():RegisterEffect(e1)
	end
end







