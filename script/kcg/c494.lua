--Number 100: Numeron Dragon
local s, id = GetID()
function s.initial_effect(c)
	--xyz summon
	c:EnableReviveLimit()
    Xyz.AddProcedure(c,nil,2,3,s.ovfilter,aux.Stringid(id,0))
	aux.EnableCheckRankUp(c,nil,nil,57314798)

	--cannot destroyed
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e0:SetValue(s.indes)
	c:RegisterEffect(e0)

	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	--c:RegisterEffect(e1)  

	--negate
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetOperation(s.negop1)
	c:RegisterEffect(e5)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_BATTLE_TARGET)
	e2:SetOperation(s.negop2)
	c:RegisterEffect(e2)

	--Gain ATK
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(23998625,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(TIMING_DAMAGE_CAL)
	e3:SetCondition(s.atkcon1)
	e3:SetCost(s.atkcost1)
	e3:SetOperation(s.atkop1)
	e3:SetLabel(RESET_EVENT+RESETS_STANDARD)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_RANKUP_EFFECT)
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4,false,EFFECT_MARKER_DETACH_XMAT)	

	--Eraser
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(57793869,0))
	e6:SetCategory(CATEGORY_DESTROY)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e6:SetCode(EVENT_DESTROYED)
	e6:SetCondition(s.erascon)
	e6:SetTarget(s.erastg)
	e6:SetOperation(s.erasop)
	e6:SetLabel(RESET_EVENT+RESETS_STANDARD)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_RANKUP_EFFECT)
	e7:SetLabelObject(e6)
	c:RegisterEffect(e7) 

	aux.GlobalCheck(s,function() 
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_DESTROYED)
		ge2:SetOperation(s.check2op)
		Duel.RegisterEffect(ge2,0)
	end)
end
s.xyz_number=100
s.listed_series={0x48}
s.listed_names={57314798,41418852}

function s.damfilter(c)
    return c:IsFaceup() and c:IsCode(41418852)
end
function s.ovfilter(c)
	return c:IsFaceup() and c:IsCode(57314798) and Duel.IsExistingMatchingCard(s.damfilter,0,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
end

function s.indes(e,c)
	return not e:GetHandler():GetBattleTarget():IsSetCard(0x48) 
	  and not e:GetHandler():GetBattleTarget():IsSetCard(0x1048) and not e:GetHandler():GetBattleTarget():IsSetCard(0x2048)
end

function s.negop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if d then
		local atk=d:GetAttack()
		--c:CreateRelation(d,RESET_EVENT+0x1fe0000)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		--e1:SetCondition(s.discon)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		d:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		--e2:SetCondition(s.discon)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		d:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(0)
		--e3:SetCondition(s.discon)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		d:RegisterEffect(e3)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(atk)
		--e4:SetCondition(s.discon)
		e4:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e4) 
	end
end
function s.negop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttacker()
	if d then
		local atk=d:GetAttack()
		--c:CreateRelation(d,RESET_EVENT+0x1fe0000)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		--e1:SetCondition(s.discon)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		d:RegisterEffect(e1)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		--e2:SetCondition(s.discon)
		e2:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		d:RegisterEffect(e2)
		local e3=Effect.CreateEffect(e:GetHandler())
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_SET_ATTACK_FINAL)
		e3:SetValue(0)
		--e3:SetCondition(s.discon)
		e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		d:RegisterEffect(e3)
		local e4=Effect.CreateEffect(e:GetHandler())
		e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_UPDATE_ATTACK)
		e4:SetValue(atk)
		--e4:SetCondition(s.discon)
		e4:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e4) 
	end
end
function s.discon(e)
	return e:GetOwner():IsRelateToCard(e:GetHandler())
end

function s.atktg(e,c)
	return c==e:GetHandler():GetBattleTarget()
end

--ATK Gain Without Numeron Network
function s.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ph=Duel.GetCurrentPhase()
	return (ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE)
end
function s.atkcost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:CheckRemoveOverlayCard(tp,1,REASON_COST) and c:GetFlagEffect(id)==0 end
	c:RemoveOverlayCard(tp,1,1,REASON_COST)
	c:RegisterFlagEffect(id,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
end
function s.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
		local val=g:GetSum(Card.GetRank)*1000
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(val)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
		c:RegisterEffect(e1)
	end
end

--Recovery
function s.filter(c,tid)
	return c:IsReason(REASON_DESTROY) and (not c:IsType(TYPE_MONSTER))
	and c:GetFlagEffect(id+511010210)>0
end
function s.erascon(e)
	return e:GetHandler():IsReason(REASON_DESTROY)
end
function s.erastg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0, CATEGORY_DESTROY, dg, #dg, 0, LOCATION_MZONE)
end
function s.erasop(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(Card.IsDestructable,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Destroy(dg,REASON_EFFECT)
	local sg=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK+LOCATION_HAND,LOCATION_GRAVE+LOCATION_REMOVED+LOCATION_DECK+LOCATION_HAND,nil,Duel.GetTurnCount())
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		while tc do
			Duel.MoveToField(tc,tp,tp,tc:GetFlagEffectLabel(id+511010208),tc:GetFlagEffectLabel(id+511010210),true)
			Duel.MoveSequence(tc,tc:GetFlagEffectLabel(id+511010211))
			tc=sg:GetNext() 
		end
		--Duel.ConfirmCards(1-tp,sg)
	end
end

function s.refilter(c, tp)
	return (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP)) and c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_SZONE)
end
function s.check2op(e, tp, eg, ep, ev, re, r, rp)
	local g = eg:Filter(s.refilter, nil, tp)
	if g:GetCount() > 0 then
		local tc = g:GetFirst()
		while tc do
			tc:ResetFlagEffect(id + 511010208)
			tc:ResetFlagEffect(id + 511010210)
			tc:ResetFlagEffect(id + 511010211)
			tc:RegisterFlagEffect(id + 511010208, RESET_PHASE + PHASE_END, 0, 1, tc:GetPreviousLocation())
			tc:RegisterFlagEffect(id + 511010210, RESET_PHASE + PHASE_END, 0, 1, tc:GetPreviousPosition())
			tc:RegisterFlagEffect(id + 511010211, RESET_PHASE + PHASE_END, 0, 1, tc:GetPreviousSequence())
			tc = g:GetNext()
		end
	end
end