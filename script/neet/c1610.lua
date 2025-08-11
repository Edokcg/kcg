--闪刀姬-燎里·疾速模式（neet）
local s,id=GetID()
function s.initial_effect(c)
	c:SetSPSummonOnce(1610)
	c:EnableReviveLimit()
	Link.AddProcedure(c,c1610.filter,1,1)

	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(c1610.actcon)
	c:RegisterEffect(e1)

	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1610,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_BATTLE_CONFIRM)
	e2:SetTarget(c1610.atktg)
	e2:SetOperation(c1610.atkop)
	c:RegisterEffect(e2)
end

function c1610.filter(c)
	return c:IsSetCard(0x1115) and c:IsType(TYPE_LINK)
end

function c1610.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end

function c1610.atktg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if chk==0 then return bc and c:GetLinkedGroup():IsContains(bc) end
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,bc,1,0,0)
end
function c1610.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=0
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_GRAVE,0,nil)
	local bc=g:GetFirst()
		while bc do
			local catk=bc:GetBaseAttack()
			if catk<0 then catk=0 end
			atk=atk+catk
			bc=g:GetNext()
		end
	local e3=Effect.CreateEffect(c)
	e3:SetValue(atk)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetReset(RESET_PHASE+PHASE_DAMAGE_CAL)
	c:RegisterEffect(e3)
end


